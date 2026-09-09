<template>
  <div class="presentes-admin">
    <!-- Header -->
    <div class="page-actions">
      <button class="btn-add" @click="openModal()">+ Novo Presente</button>
    </div>

    <!-- Grid de presentes -->
    <div v-if="loading" class="loading-state">Carregando presentes...</div>
    <div v-else-if="!presentes?.length" class="empty-state-big">
      <span>🎁</span>
      <p>Nenhum presente cadastrado ainda.</p>
      <button class="btn-add" @click="openModal()">Adicionar o primeiro presente</button>
    </div>
    <div v-else class="presentes-grid">
      <div v-for="p in presentes" :key="p.id" class="presente-card">
        <div class="presente-img">
          <img v-if="p.imagem_url" :src="p.imagem_url" :alt="p.nome" />
          <div v-else class="presente-img-placeholder">🎁</div>
          <span class="presente-status" :class="p.reservado ? 'reservado' : 'disponivel'">
            {{ p.reservado ? 'Reservado' : 'Disponível' }}
          </span>
        </div>
        <div class="presente-info">
          <div class="presente-cat">{{ p.categoria }}</div>
          <div class="presente-nome">{{ p.nome }}</div>
          <div class="presente-valor">{{ formatMoney(p.valor) }}</div>
          <div v-if="p.descricao" class="presente-desc">{{ p.descricao }}</div>
        </div>
        <div class="presente-actions">
          <button class="btn-action edit" @click="openModal(p)">✏️ Editar</button>
          <button class="btn-action toggle" @click="toggleReservado(p)">
            {{ p.reservado ? '🔓 Liberar' : '🔒 Reservar' }}
          </button>
          <button class="btn-action delete" @click="deletePresente(p.id)">🗑️ Excluir</button>
        </div>
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
const showModal = ref(false)
const editingId = ref<number | null>(null)
const saving    = ref(false)
const saveError = ref('')
const previewUrl = ref('')
const selectedFile = ref<File | null>(null)
const fileInput = ref<HTMLInputElement | null>(null)

const categorias = ['Casa', 'Cozinha', 'Quarto', 'Sala', 'Viagem', 'Experiências', 'Divertidos', 'Outro']

const form = reactive({
  nome: '', categoria: '', valor: '', descricao: '',
})

async function loadPresentes() {
  loading.value = true
  const { data } = await (client.from('vc_presentes') as any).select('*').order('ordem').order('created_at')
  presentes.value = data ?? []
  loading.value = false
}

await loadPresentes()

function openModal(p?: any) {
  editingId.value = p?.id ?? null
  form.nome      = p?.nome ?? ''
  form.categoria = p?.categoria ?? ''
  form.valor     = p?.valor ?? ''
  form.descricao = p?.descricao ?? ''
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

    const payload = {
      nome:       form.nome,
      categoria:  form.categoria,
      valor:      Number(form.valor),
      descricao:  form.descricao || null,
      imagem_url: imagem_url || null,
    }

    if (editingId.value) {
      await (client.from('vc_presentes') as any).update(payload).eq('id', editingId.value)
    } else {
      await (client.from('vc_presentes') as any).insert(payload)
    }

    closeModal()
    await loadPresentes()
  } catch (e: any) {
    saveError.value = e.message ?? 'Erro ao salvar.'
  } finally {
    saving.value = false
  }
}

async function deletePresente(id: number) {
  if (!confirm('Excluir este presente?')) return
  await (client.from('vc_presentes') as any).delete().eq('id', id)
  await loadPresentes()
}

async function toggleReservado(p: any) {
  await (client.from('vc_presentes') as any).update({ reservado: !p.reservado }).eq('id', p.id)
  p.reservado = !p.reservado
}

function formatMoney(v: number) {
  return new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(v)
}
</script>

<style scoped>
.presentes-admin { display: flex; flex-direction: column; gap: 24px; }

.page-actions { display: flex; justify-content: flex-end; }

.btn-add {
  padding: 10px 22px;
  background: linear-gradient(135deg, var(--rose-gold-dark), var(--rose-gold));
  color: white;
  border-radius: var(--radius-full);
  font-size: 0.875rem;
  font-weight: 600;
  transition: var(--transition);
  box-shadow: 0 4px 12px rgba(201,150,125,0.3);
}
.btn-add:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(201,150,125,0.4); }

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
}
.presente-card:hover { border-color: rgba(201,150,125,0.25); transform: translateY(-3px); }

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
  padding: 3px 10px; border-radius: var(--radius-full);
  font-size: 0.68rem; font-weight: 700;
  text-transform: uppercase; letter-spacing: 0.05em;
}
.reservado   { background: rgba(239,68,68,0.2); color: #fca5a5; }
.disponivel  { background: rgba(34,197,94,0.2); color: #86efac; }

.presente-info { padding: 14px 16px; }
.presente-cat  { font-size: 0.7rem; color: var(--rose-gold-light); text-transform: uppercase; letter-spacing: 0.1em; margin-bottom: 4px; }
.presente-nome { font-size: 0.95rem; font-weight: 600; color: var(--admin-text); margin-bottom: 4px; }
.presente-valor{ font-size: 1rem; color: var(--rose-gold-light); font-family: var(--font-serif); font-weight: 600; }
.presente-desc { font-size: 0.75rem; color: var(--admin-text-light); margin-top: 6px; line-height: 1.5; }

.presente-actions {
  display: flex;
  gap: 4px;
  padding: 0 12px 12px;
}
.btn-action {
  flex: 1;
  padding: 7px 4px;
  border-radius: var(--radius-sm);
  font-size: 0.7rem;
  font-weight: 500;
  transition: var(--transition);
  border: 1px solid var(--admin-border);
  color: var(--admin-text-light);
  background: transparent;
  text-align: center;
}
.btn-action:hover        { background: rgba(255,255,255,0.06); color: var(--admin-text); }
.btn-action.delete:hover { background: rgba(239,68,68,0.1); color: #ef4444; border-color: rgba(239,68,68,0.3); }

/* Modal */
.modal-overlay {
  position: fixed; inset: 0;
  background: rgba(0,0,0,0.7);
  display: flex; align-items: center; justify-content: center;
  z-index: 1000; padding: 16px;
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
.modal-close { color: var(--admin-text-light); font-size: 1rem; transition: var(--transition); }
.modal-close:hover { color: var(--admin-text); }
.modal-body { padding: 24px; display: flex; flex-direction: column; gap: 20px; }

.form-group label { color: var(--admin-text-light); }
.form-group input,
.form-group select,
.form-group textarea {
  background: rgba(255,255,255,0.05);
  border-color: var(--admin-border);
  color: var(--admin-text);
}
.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
  border-color: var(--rose-gold);
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
.img-upload:hover { border-color: var(--rose-gold); }
.img-upload img { width: 100%; height: 180px; object-fit: cover; }
.img-upload-placeholder { display: flex; flex-direction: column; align-items: center; gap: 8px; color: var(--admin-text-light); }
.img-upload-placeholder span { font-size: 2rem; }
.img-upload-placeholder p { font-size: 0.85rem; }
.img-upload-placeholder small { font-size: 0.72rem; color: #555; }

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
}
.btn-cancel:hover { background: rgba(255,255,255,0.05); color: var(--admin-text); }
.btn-save {
  flex: 2; padding: 12px;
  background: linear-gradient(135deg, var(--rose-gold-dark), var(--rose-gold));
  color: white;
  border-radius: var(--radius-full);
  font-size: 0.875rem;
  font-weight: 600;
  transition: var(--transition);
}
.btn-save:hover:not(:disabled) { transform: translateY(-1px); box-shadow: 0 6px 16px rgba(201,150,125,0.35); }
.btn-save:disabled { opacity: 0.5; cursor: not-allowed; }
</style>
