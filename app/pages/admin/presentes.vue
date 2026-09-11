<template>
  <div class="presentes-admin">
    <!-- Header & Tabs -->
    <div class="header-nav">
      <div class="admin-tabs">
        <button class="tab-btn" :class="{ active: currentTab === 'grid' }" @click="currentTab = 'grid'">
          🎁 Catálogo de Presentes ({{ presentes.length }})
        </button>
        <button class="tab-btn" :class="{ active: currentTab === 'contribuicoes' }" @click="currentTab = 'contribuicoes'">
          💖 Presentes Recebidos / Contribuições ({{ contribuicoes.length }})
        </button>
      </div>
      <div class="page-actions">
        <button class="btn-add" @click="openModal()">+ Novo Presente</button>
      </div>
    </div>

    <!-- TAB 1: GRID DE PRESENTES -->
    <div v-if="currentTab === 'grid'">
      <div v-if="loading" class="loading-state">Carregando presentes...</div>
      <div v-else-if="!presentes?.length" class="empty-state-big">
        <span>🎁</span>
        <p>Nenhum presente cadastrado ainda.</p>
        <button class="btn-add" @click="openModal()">Adicionar presente</button>
      </div>
      <div v-else class="presentes-grid">
        <div v-for="p in presentes" :key="p.id" class="presente-card">
          <div class="presente-img">
            <img v-if="p.imagem_url" :src="p.imagem_url" :alt="p.nome" />
            <div v-else class="presente-img-placeholder">🎁</div>
          </div>
          <div class="presente-info">
            <div class="presente-cat">{{ p.categoria }}</div>
            <div class="presente-nome">{{ p.nome }}</div>
            <div class="presente-valor">{{ formatMoney(p.valor) }}</div>
            <div v-if="p.descricao" class="presente-desc">{{ p.descricao }}</div>
          </div>
          <div class="presente-actions">
            <button class="btn-action edit" @click="openModal(p)">✏️ Editar</button>
            <button class="btn-action delete" @click="deletePresente(p.id)">🗑️ Excluir</button>
          </div>
        </div>
      </div>
    </div>

    <!-- TAB 2: HISTÓRICO DE PRESENTES RECEBIDOS / CONTRIBUIÇÕES -->
    <div v-else-if="currentTab === 'contribuicoes'">
      <div v-if="loading" class="loading-state">Carregando contribuições...</div>
      <div v-else-if="!contribuicoes?.length" class="empty-state-big">
        <span>💝</span>
        <p>Nenhum presente ou contribuição recebida até o momento.</p>
      </div>
      <div v-else class="contribuicoes-table-wrap">
        <table class="contribuicoes-table">
          <thead>
            <tr>
              <th>Quem Presenteou</th>
              <th>Presente / Item</th>
              <th>Valor Contribuído</th>
              <th>Data do Presente</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="c in contribuicoes" :key="c.id">
              <td class="td-nome">
                <div class="contrib-user">
                  <span class="user-avatar">{{ (c.nome_contribuidor || 'C')[0]?.toUpperCase() }}</span>
                  <div>
                    <strong>{{ c.nome_contribuidor }}</strong>
                  </div>
                </div>
              </td>
              <td class="td-presente">
                {{ c.vc_presentes?.nome || getPresenteNome(c.presente_id) || 'Presente Reservado' }}
              </td>
              <td class="td-valor">{{ formatMoney(c.valor_contribuido) }}</td>
              <td class="td-data">{{ formatDate(c.created_at) }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Modal de CRUD -->
    <Teleport to="body">
      <div v-if="showModal" class="modal-overlay" @click.self="closeModal">
        <div class="modal-box">
          <div class="modal-header">
            <h2>{{ editingId ? 'Editar Presente' : 'Novo Presente' }}</h2>
            <button class="modal-close" @click="closeModal">✕</button>
          </div>
          <div class="modal-body">
            <form @submit.prevent="savePresente">

              <!-- Upload de imagem -->
              <div class="form-group">
                <label>Imagem do Presente</label>
                <div class="img-upload" :class="{ hasimg: previewUrl }" @click="(fileInput as HTMLInputElement)?.click()">
                  <input ref="fileInput" type="file" accept="image/*" style="display:none" @change="handleFile" />
                  <img v-if="previewUrl" :src="previewUrl" alt="preview" />
                  <div v-else class="img-upload-placeholder">
                    <span>🖼️</span>
                    <p>Clique para fazer upload</p>
                    <small>JPG, PNG ou WEBP · Máx. 5MB</small>
                  </div>
                </div>
              </div>

              <div class="form-row">
                <div class="form-group">
                  <label for="pNome">Nome *</label>
                  <input id="pNome" v-model="form.nome" type="text" placeholder="Ex: Cama Queen" required maxlength="75" />
                </div>
                <div class="form-group">
                  <label for="pCategoria">Categoria *</label>
                  <select id="pCategoria" v-model="form.categoria" required>
                    <option value="">Selecionar...</option>
                    <option v-for="cat in categorias" :key="cat" :value="cat">{{ cat }}</option>
                  </select>
                </div>
              </div>

              <div class="form-group">
                <label for="pValor">Valor (R$) *</label>
                <input id="pValor" v-model="form.valor" type="number" placeholder="0.00" min="1" step="0.01" required />
              </div>

              <div class="form-group">
                <label for="pLink">Link de Pagamento (ex: Mercado Pago, Pix) 🔗</label>
                <input id="pLink" v-model="form.link_pagamento" type="url" placeholder="Ex: https://mpago.li/2j3LbfH" />
                <small style="font-size:0.75rem; color:var(--admin-text-light); margin-top:2px;">
                  Se informado, o convidado será redirecionado para este link ao presentear.
                </small>
              </div>

              <div class="form-group">
                <label for="pDesc">Descrição (opcional)</label>
                <textarea id="pDesc" v-model="form.descricao" rows="3" placeholder="Conte um pouco sobre este presente..."></textarea>
              </div>

              <div v-if="saveError" class="form-error">{{ saveError }}</div>

              <div class="modal-footer">
                <button type="button" class="btn-cancel" @click="closeModal">Cancelar</button>
                <button type="submit" class="btn-save" :disabled="saving">
                  {{ saving ? 'Salvando...' : '✅ Salvar Presente' }}
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup lang="ts">
definePageMeta({ layout: 'admin', middleware: ['admin'] })
useHead({ title: 'Presentes — VouCasar Admin' })

const client  = useSupabaseClient()
const loading = ref(true)
const presentes = ref<any[]>([])
const contribuicoes = ref<any[]>([])

const currentTab   = ref<'grid' | 'contribuicoes'>('grid')
const statusFilter = ref<'todos' | 'disponivel' | 'reservado'>('todos')

const showModal = ref(false)
const editingId = ref<number | null>(null)
const saving    = ref(false)
const saveError = ref('')
const previewUrl = ref('')
const selectedFile = ref<File | null>(null)
const fileInput = ref<HTMLInputElement | null>(null)

const categorias = ['Casa', 'Cozinha', 'Quarto', 'Sala', 'Viagem', 'Experiências', 'Divertidos', 'Outro']

const form = reactive({
  nome: '', categoria: '', valor: '', descricao: '', link_pagamento: '',
})

const disponiveisCount = computed(() => presentes.value.filter(p => !p.reservado).length)
const reservadosCount  = computed(() => presentes.value.filter(p => p.reservado).length)

const filteredPresentes = computed(() => {
  if (statusFilter.value === 'disponivel') return presentes.value.filter(p => !p.reservado)
  if (statusFilter.value === 'reservado') return presentes.value.filter(p => p.reservado)
  return presentes.value
})

function parseGift(p: any) {
  let link = p.link_pagamento || ''
  let desc = p.descricao || ''
  if (!link && desc.includes('[LINK:')) {
    const match = desc.match(/\[LINK:\s*(.*?)\]/)
    if (match) {
      link = match[1].trim()
      desc = desc.replace(/\[LINK:\s*.*?\]/, '').trim()
    }
  }
  return { ...p, descricao: desc, link_pagamento: link }
}

async function loadData() {
  loading.value = true
  const [{ data: pData }, { data: cData }] = await Promise.all([
    (client.from('vc_presentes') as any).select('*').order('ordem').order('created_at'),
    (client.from('vc_contribuicoes') as any).select('*, vc_presentes(nome)').order('created_at', { ascending: false }),
  ])
  presentes.value = (pData ?? []).map(parseGift)
  contribuicoes.value = cData ?? []
  loading.value = false
}

await loadData()

function openModal(p?: any) {
  editingId.value = p?.id ?? null
  form.nome      = p?.nome ?? ''
  form.categoria = p?.categoria ?? ''
  form.valor     = p?.valor ?? ''
  form.descricao = p?.descricao ?? ''
  form.link_pagamento = p?.link_pagamento ?? ''
  previewUrl.value  = p?.imagem_url ?? ''
  selectedFile.value = null
  saveError.value    = ''
  showModal.value    = true
}

function closeModal() {
  showModal.value = false
}

function handleFile(e: Event) {
  const file = (e.target as HTMLInputElement).files?.[0]
  if (!file) return
  if (file.size > 5 * 1024 * 1024) { saveError.value = 'Imagem muito grande (máx. 5MB)'; return }
  selectedFile.value = file
  previewUrl.value   = URL.createObjectURL(file)
}

async function uploadImage(file: File): Promise<string> {
  const ext = file.name.split('.').pop()
  const path = `${Date.now()}.${ext}`
  const { error } = await client.storage.from('presentes').upload(path, file, { upsert: true })
  if (error) throw error
  const { data } = client.storage.from('presentes').getPublicUrl(path)
  return data.publicUrl
}

async function savePresente() {
  saving.value    = true
  saveError.value = ''
  try {
    let imagem_url = previewUrl.value
    if (selectedFile.value) {
      imagem_url = await uploadImage(selectedFile.value)
    }

    const cleanLink = form.link_pagamento ? form.link_pagamento.trim() : ''
    const cleanDesc = form.descricao ? form.descricao.trim() : ''

    // Payload 1: Tentativa com coluna link_pagamento
    let payload: any = {
      nome:           form.nome,
      categoria:      form.categoria,
      valor:          Number(form.valor),
      descricao:      cleanDesc || null,
      imagem_url:     imagem_url || null,
      link_pagamento: cleanLink || null,
    }

    let res: any
    if (editingId.value) {
      res = await (client.from('vc_presentes') as any).update(payload).eq('id', editingId.value)
    } else {
      res = await (client.from('vc_presentes') as any).insert(payload)
    }

    // Se a coluna link_pagamento não existir na tabela do Supabase, tenta fallback salvando o link embutido na descrição
    if (res?.error) {
      console.warn('Tentando fallback de salvamento sem coluna link_pagamento...', res.error)
      let descComLink = cleanDesc
      if (cleanLink) {
        descComLink = descComLink ? `${descComLink}\n[LINK: ${cleanLink}]` : `[LINK: ${cleanLink}]`
      }

      payload = {
        nome:       form.nome,
        categoria:  form.categoria,
        valor:      Number(form.valor),
        descricao:  descComLink || null,
        imagem_url: imagem_url || null,
      }

      if (editingId.value) {
        res = await (client.from('vc_presentes') as any).update(payload).eq('id', editingId.value)
      } else {
        res = await (client.from('vc_presentes') as any).insert(payload)
      }

      if (res?.error) {
        throw new Error(res.error.message || 'Erro ao salvar no banco de dados.')
      }
    }

    closeModal()
    await loadData()
  } catch (e: any) {
    console.error('Erro ao salvar presente:', e)
    saveError.value = e.message ?? 'Erro ao salvar presente.'
  } finally {
    saving.value = false
  }
}

async function deletePresente(id: number) {
  if (!confirm('Excluir este presente?')) return
  const { error } = await (client.from('vc_presentes') as any).delete().eq('id', id)
  if (error) {
    alert('Erro ao excluir: ' + error.message)
    return
  }
  await loadData()
}

async function toggleReservado(p: any) {
  const nextReservado = !p.reservado
  const updatePayload = nextReservado
    ? { reservado: true, reservado_por: 'Reservado pelo Admin', reservado_at: new Date().toISOString() }
    : { reservado: false, reservado_por: null, reservado_at: null }

  await (client.from('vc_presentes') as any).update(updatePayload).eq('id', p.id)
  p.reservado = nextReservado
  p.reservado_por = updatePayload.reservado_por
  p.reservado_at = updatePayload.reservado_at
}

function getPresenteNome(id: number) {
  const found = presentes.value.find(p => p.id === id)
  return found?.nome || ''
}

function formatDate(d: string) {
  if (!d) return ''
  return new Date(d).toLocaleDateString('pt-BR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

function formatMoney(v: number) {
  return new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(v ?? 0)
}
</script>

<style scoped>
.presentes-admin { display: flex; flex-direction: column; gap: 24px; }

/* Header Nav & Tabs */
.header-nav {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  flex-wrap: wrap;
  border-bottom: 1px solid var(--admin-border);
  padding-bottom: 16px;
}
.admin-tabs {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}
.tab-btn {
  padding: 10px 18px;
  border-radius: var(--radius-sm);
  background: rgba(255,255,255,0.03);
  border: 1px solid var(--admin-border);
  color: var(--admin-text-light);
  font-size: 0.85rem;
  font-weight: 500;
  cursor: pointer;
  transition: var(--transition);
}
.tab-btn.active, .tab-btn:hover {
  background: rgba(232, 184, 75, 0.12);
  border-color: rgba(232, 184, 75, 0.35);
  color: var(--gold-light);
}

.page-actions { display: flex; justify-content: flex-end; }

.btn-add {
  padding: 10px 22px;
  background: linear-gradient(135deg, var(--sun-600), var(--sun-500));
  color: white;
  border-radius: var(--radius-full);
  font-size: 0.875rem;
  font-weight: 600;
  transition: var(--transition);
  box-shadow: var(--shadow-gold);
  border: none;
  cursor: pointer;
}
.btn-add:hover { transform: translateY(-2px); box-shadow: var(--shadow-gold-lg); }

/* Sub-filtros */
.sub-filters {
  display: flex;
  gap: 8px;
  margin-bottom: 16px;
}
.sub-filter-btn {
  padding: 6px 14px;
  border-radius: var(--radius-full);
  border: 1px solid var(--admin-border);
  background: transparent;
  color: var(--admin-text-light);
  font-size: 0.78rem;
  cursor: pointer;
  transition: var(--transition);
}
.sub-filter-btn.active, .sub-filter-btn:hover {
  background: rgba(232, 184, 75, 0.15);
  border-color: var(--gold-light);
  color: var(--gold-light);
}

.loading-state, .empty-state-big {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 16px;
  min-height: 200px;
  color: var(--admin-text-light);
  font-size: 0.9rem;
}
.empty-state-big span { font-size: 3rem; }

.presentes-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
  gap: 20px;
}

.presente-card {
  background: var(--admin-card);
  border: 1px solid var(--admin-border);
  border-radius: var(--radius-md);
  overflow: hidden;
  transition: var(--transition);
  display: flex;
  flex-direction: column;
}
.presente-card.is-reservado {
  border-color: rgba(232, 184, 75, 0.35);
}
.presente-card:hover { border-color: rgba(232, 184, 75, 0.4); transform: translateY(-3px); }

.presente-img {
  position: relative;
  height: 160px;
  background: rgba(255,255,255,0.03);
  overflow: hidden;
}
.presente-img img { width: 100%; height: 100%; object-fit: cover; }
.presente-img-placeholder {
  display: flex; align-items: center; justify-content: center;
  height: 100%; font-size: 3rem; opacity: 0.3;
}
.presente-status {
  position: absolute; top: 10px; right: 10px;
  padding: 4px 12px; border-radius: var(--radius-full);
  font-size: 0.68rem; font-weight: 700;
  text-transform: uppercase; letter-spacing: 0.05em;
}
.reservado   { background: rgba(234,179,8,0.25); color: #fef08a; border: 1px solid rgba(234,179,8,0.4); }
.disponivel  { background: rgba(34,197,94,0.2); color: #86efac; border: 1px solid rgba(34,197,94,0.3); }

.presente-info { padding: 16px; flex: 1; display: flex; flex-direction: column; }
.presente-cat  { font-size: 0.7rem; color: var(--gold-light); text-transform: uppercase; letter-spacing: 0.1em; margin-bottom: 4px; }
.presente-nome { font-size: 0.95rem; font-weight: 600; color: var(--admin-text); margin-bottom: 4px; }
.presente-valor{ font-size: 1.1rem; color: var(--gold-warm); font-family: var(--font-serif); font-weight: 600; font-variant-numeric: lining-nums tabular-nums; }
.presente-desc { font-size: 0.75rem; color: var(--admin-text-light); margin-top: 6px; line-height: 1.5; }

/* Box Reservado */
.presente-reservado-box {
  margin-top: 12px;
  padding: 10px 12px;
  background: rgba(232, 184, 75, 0.08);
  border: 1px solid rgba(232, 184, 75, 0.25);
  border-radius: var(--radius-sm);
  font-size: 0.78rem;
}
.reservado-by { color: var(--gold-light); }
.reservado-date { font-size: 0.7rem; color: var(--admin-text-light); margin-top: 2px; }

.presente-actions {
  display: flex;
  gap: 6px;
  padding: 12px;
  border-top: 1px solid var(--admin-border);
}
.btn-action {
  flex: 1;
  padding: 8px 4px;
  border-radius: var(--radius-sm);
  font-size: 0.72rem;
  font-weight: 500;
  transition: var(--transition);
  border: 1px solid var(--admin-border);
  color: var(--admin-text-light);
  background: transparent;
  text-align: center;
  cursor: pointer;
}
.btn-action:hover        { background: rgba(255,255,255,0.06); color: var(--admin-text); }
.btn-action.delete:hover { background: rgba(239,68,68,0.1); color: #ef4444; border-color: rgba(239,68,68,0.3); }

/* Tabela de Contribuições */
.contribuicoes-table-wrap {
  background: var(--admin-card);
  border: 1px solid var(--admin-border);
  border-radius: var(--radius-md);
  overflow-x: auto;
}
.contribuicoes-table {
  width: 100%;
  border-collapse: collapse;
  text-align: left;
  font-size: 0.85rem;
}
.contribuicoes-table th {
  padding: 16px 20px;
  background: rgba(255,255,255,0.02);
  border-bottom: 1px solid var(--admin-border);
  color: var(--gold-light);
  font-size: 0.75rem;
  text-transform: uppercase;
  letter-spacing: 0.08em;
}
.contribuicoes-table td {
  padding: 16px 20px;
  border-bottom: 1px solid var(--admin-border);
  color: var(--admin-text);
}
.contribuicoes-table tr:last-child td { border-bottom: none; }
.contrib-user { display: flex; align-items: center; gap: 12px; }
.user-avatar {
  width: 32px; height: 32px;
  border-radius: 50%;
  background: linear-gradient(135deg, var(--sun-600), var(--gold-warm));
  color: white; font-weight: 700;
  display: flex; align-items: center; justify-content: center;
  font-size: 0.8rem;
}
.td-valor { font-weight: 600; color: var(--gold-warm); font-family: var(--font-serif); font-size: 1rem; }
.td-data { color: var(--admin-text-light); font-size: 0.78rem; }

/* Modal */
.modal-overlay {
  position: fixed; inset: 0;
  background: rgba(0,0,0,0.75);
  display: flex; align-items: center; justify-content: center;
  z-index: 1000; padding: 16px;
  backdrop-filter: blur(6px);
}
.modal-box {
  background: var(--admin-card);
  border: 1px solid var(--admin-border);
  border-radius: var(--radius-lg);
  width: 100%; max-width: 520px;
  max-height: 90vh; overflow-y: auto;
  box-shadow: 0 24px 80px rgba(0,0,0,0.5);
}
.modal-header {
  display: flex; align-items: center; justify-content: space-between;
  padding: 20px 24px;
  border-bottom: 1px solid var(--admin-border);
}
.modal-header h2 { font-size: 1rem; font-weight: 600; color: var(--admin-text); }
.modal-close { color: var(--admin-text-light); font-size: 1rem; transition: var(--transition); background: transparent; border: none; cursor: pointer; }
.modal-close:hover { color: var(--admin-text); }
.modal-body { padding: 24px; display: flex; flex-direction: column; gap: 20px; }

.form-group label { color: var(--admin-text-light); font-size: 0.78rem; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 6px; display: block; }
.form-group input,
.form-group select,
.form-group textarea {
  width: 100%;
  padding: 10px 14px;
  background: rgba(255,255,255,0.05);
  border: 1px solid var(--admin-border);
  border-radius: var(--radius-sm);
  color: var(--admin-text);
  font-family: inherit;
  font-size: 0.9rem;
  outline: none;
}
.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
  border-color: var(--gold-light);
  background: rgba(255,255,255,0.07);
}
.form-group select option { background: #1a1a1a; }
.form-group textarea { resize: vertical; }

.img-upload {
  border: 2px dashed var(--admin-border);
  border-radius: var(--radius-md);
  min-height: 140px;
  display: flex; align-items: center; justify-content: center;
  cursor: pointer;
  transition: var(--transition);
  overflow: hidden;
}
.img-upload:hover { border-color: var(--gold-light); }
.img-upload img { width: 100%; height: 180px; object-fit: cover; }
.img-upload-placeholder { display: flex; flex-direction: column; align-items: center; gap: 8px; color: var(--admin-text-light); }
.img-upload-placeholder span { font-size: 2rem; }
.img-upload-placeholder p { font-size: 0.85rem; }
.img-upload-placeholder small { font-size: 0.72rem; color: #666; }

.form-error {
  background: rgba(239,68,68,0.1);
  border: 1px solid rgba(239,68,68,0.3);
  color: #fca5a5;
  padding: 10px 14px;
  border-radius: var(--radius-sm);
  font-size: 0.8rem;
}

.modal-footer {
  display: flex; gap: 12px;
  padding-top: 8px;
}
.btn-cancel {
  flex: 1; padding: 12px;
  border: 1px solid var(--admin-border);
  border-radius: var(--radius-full);
  color: var(--admin-text-light);
  font-size: 0.875rem;
  transition: var(--transition);
  background: transparent;
  cursor: pointer;
}
.btn-cancel:hover { background: rgba(255,255,255,0.05); color: var(--admin-text); }
.btn-save {
  flex: 2; padding: 12px;
  background: linear-gradient(135deg, var(--sun-600), var(--sun-500));
  color: white;
  border-radius: var(--radius-full);
  font-size: 0.875rem;
  font-weight: 600;
  transition: var(--transition);
  border: none;
  cursor: pointer;
}
.btn-save:hover:not(:disabled) { transform: translateY(-1px); box-shadow: var(--shadow-gold); }
.btn-save:disabled { opacity: 0.5; cursor: not-allowed; }
</style>
