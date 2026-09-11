<template>
  <div class="confirmacoes-admin">
    <!-- Header e ações topo -->
    <div class="page-actions-header">
      <div class="header-titles">
        <h1 class="admin-page-title">🥂 Confirmações de Presença</h1>
        <p class="admin-page-sub">Gerencie manualmente a lista de convidados e acompanhantes do casamento.</p>
      </div>
      <button class="btn-add" @click="openModal()">+ Nova Confirmação</button>
    </div>

    <!-- Resumo Grid -->
    <div class="resumo-grid">
      <div class="resumo-card">
        <span class="resumo-icon">✅</span>
        <div class="resumo-num">{{ confirmados }}</div>
        <div class="resumo-label">Confirmados</div>
      </div>
      <div class="resumo-card">
        <span class="resumo-icon">❌</span>
        <div class="resumo-num">{{ naoVao }}</div>
        <div class="resumo-label">Não vão</div>
      </div>
      <div class="resumo-card">
        <span class="resumo-icon">👥</span>
        <div class="resumo-num">{{ totalPessoas }}</div>
        <div class="resumo-label">Total de Pessoas (Convidados + Acomp.)</div>
      </div>
    </div>

    <!-- Filtro de busca -->
    <div class="search-row">
      <input v-model="search" type="text" placeholder="🔍 Buscar por nome, e-mail ou observação..." class="search-input" />
      <button class="btn-export" @click="exportExcel">📊 Exportar Excel</button>
    </div>

    <!-- Tabela -->
    <div class="table-container">
      <div v-if="loading" class="loading-state">Carregando confirmações...</div>
      <div v-else-if="!filtered.length" class="empty-state-big">
        <span>🥂</span>
        <p>Nenhuma confirmação cadastrada ainda.</p>
        <button class="btn-add" @click="openModal()">Adicionar a primeira confirmação</button>
      </div>
      <table v-else class="conf-table">
        <thead>
          <tr>
            <th>Nome do Convidado</th>
            <th>Contato / E-mail</th>
            <th>Status</th>
            <th>Acompanhantes</th>
            <th>Restrição Alimentar / Obs</th>
            <th>Data</th>
            <th class="th-actions">Ações</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="conf in filtered" :key="conf.id">
            <td class="td-nome">{{ conf.nome }}</td>
            <td class="td-email">{{ conf.email || '—' }}</td>
            <td>
              <span class="admin-badge" :class="conf.confirmacao === 'sim' ? 'badge-green' : 'badge-red'">
                {{ conf.confirmacao === 'sim' ? 'Confirmado' : 'Não vai' }}
              </span>
            </td>
            <td>{{ conf.acompanhantes || 0 }} acomp.</td>
            <td class="td-restricao">
              <div v-if="conf.restricao_alimentar">🥗 <strong>Restrição:</strong> {{ conf.restricao_alimentar }}</div>
              <div v-if="conf.observacoes">📝 {{ conf.observacoes }}</div>
              <span v-if="!conf.restricao_alimentar && !conf.observacoes">—</span>
            </td>
            <td class="td-data">{{ formatDate(conf.created_at) }}</td>
            <td class="td-actions">
              <button class="btn-action edit" title="Editar" @click="openModal(conf)">✏️ Editar</button>
              <button class="btn-action delete" title="Excluir" @click="deleteConf(conf.id)">🗑️ Excluir</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Modal Form Principal -->
    <Teleport to="body">
      <div v-if="showModal" class="modal-overlay" @click.self="closeModal">
        <div class="modal-box">
          <div class="modal-header">
            <h2>{{ editingId ? 'Editar Confirmação' : 'Nova Confirmação Manual' }}</h2>
            <button class="modal-close" @click="closeModal">✕</button>
          </div>

          <form @submit.prevent="saveConf">
            <div class="modal-body">
              <div class="form-group">
                <label for="confNome">NOME COMPLETO DO CONVIDADO *</label>
                <input id="confNome" v-model="form.nome" type="text" placeholder="Ex: Maria da Silva" required />
              </div>

              <div class="form-row">
                <div class="form-group">
                  <label for="confEmail">TELEFONE OU E-MAIL</label>
                  <input id="confEmail" v-model="form.email" type="text" placeholder="(67) 99999-9999" />
                </div>
                <div class="form-group">
                  <label for="confAcomp">Nº DE ACOMPANHANTES</label>
                  <select id="confAcomp" v-model="form.acompanhantes">
                    <option :value="0">Somente o convidado (0)</option>
                    <option :value="1">+ 1 acompanhante</option>
                    <option :value="2">+ 2 acompanhantes</option>
                    <option :value="3">+ 3 acompanhantes</option>
                    <option :value="4">+ 4 acompanhantes</option>
                    <option :value="5">+ 5 ou mais acompanhantes</option>
                  </select>
                </div>
              </div>

              <div class="form-group">
                <label>STATUS DE PRESENÇA *</label>
                <div class="status-options">
                  <label class="status-option-btn" :class="{ active: form.confirmacao === 'sim' }">
                    <input type="radio" v-model="form.confirmacao" value="sim" style="display:none" />
                    <span>✅ Confirmado</span>
                  </label>
                  <label class="status-option-btn red" :class="{ active: form.confirmacao === 'nao' }">
                    <input type="radio" v-model="form.confirmacao" value="nao" style="display:none" />
                    <span>❌ Não Vai</span>
                  </label>
                </div>
              </div>

              <div class="form-group">
                <label for="confRestricao">RESTRIÇÃO ALIMENTAR (OPCIONAL)</label>
                <input id="confRestricao" v-model="form.restricao_alimentar" type="text" placeholder="Ex: Vegetariano, Sem glúten, Intolerante a lactose" />
              </div>

              <div class="form-group">
                <label for="confObs">OBSERVAÇÕES INTERNAS (OPCIONAL)</label>
                <textarea id="confObs" v-model="form.observacoes" rows="2" placeholder="Ex: Parente da noiva, precisa de assento preferencial..."></textarea>
              </div>
            </div>

            <div class="modal-footer">
              <button type="button" class="btn-cancel" @click="closeModal">Cancelar</button>
              <button type="submit" class="btn-save" :disabled="saving">
                {{ saving ? 'Salvando...' : (editingId ? 'Salvar Alterações' : 'Adicionar Confirmação') }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup lang="ts">
definePageMeta({ layout: 'admin', middleware: ['admin'] })
useHead({ title: 'Confirmações — VouCasar Admin' })

const client  = useSupabaseClient()
const loading = ref(true)
const saving  = ref(false)
const confs   = ref<any[]>([])
const search  = ref('')

const showModal = ref(false)
const editingId = ref<number | null>(null)

const form = reactive({
  nome: '',
  email: '',
  confirmacao: 'sim',
  acompanhantes: 0,
  restricao_alimentar: '',
  observacoes: ''
})

async function load() {
  loading.value = true
  const { data } = await client.from('vc_confirmacoes').select('*').order('created_at', { ascending: false })
  confs.value = data ?? []
  loading.value = false
}
await load()

const filtered = computed(() => {
  if (!search.value) return confs.value
  const q = search.value.toLowerCase()
  return confs.value.filter(c =>
    (c.nome && c.nome.toLowerCase().includes(q)) ||
    (c.email && c.email.toLowerCase().includes(q)) ||
    (c.observacoes && c.observacoes.toLowerCase().includes(q)) ||
    (c.restricao_alimentar && c.restricao_alimentar.toLowerCase().includes(q))
  )
})

const confirmados   = computed(() => confs.value.filter(c => c.confirmacao === 'sim').length)
const naoVao        = computed(() => confs.value.filter(c => c.confirmacao !== 'sim').length)
const totalPessoas  = computed(() =>
  confs.value.filter(c => c.confirmacao === 'sim')
             .reduce((acc, c) => acc + 1 + Number(c.acompanhantes ?? 0), 0)
)

function formatDate(d: string) {
  if (!d) return '—'
  return new Date(d).toLocaleDateString('pt-BR', { day: '2-digit', month: '2-digit', year: 'numeric' })
}

function openModal(conf?: any) {
  if (conf) {
    editingId.value = conf.id
    form.nome = conf.nome ?? ''
    form.email = conf.email ?? ''
    form.confirmacao = conf.confirmacao ?? 'sim'
    form.acompanhantes = conf.acompanhantes ?? 0
    form.restricao_alimentar = conf.restricao_alimentar ?? ''
    form.observacoes = conf.observacoes ?? ''
  } else {
    editingId.value = null
    form.nome = ''
    form.email = ''
    form.confirmacao = 'sim'
    form.acompanhantes = 0
    form.restricao_alimentar = ''
    form.observacoes = ''
  }
  showModal.value = true
}

function closeModal() {
  showModal.value = false
  editingId.value = null
}

async function saveConf() {
  if (!form.nome.trim() || saving.value) return
  saving.value = true
  try {
    const payload = {
      nome: form.nome.trim(),
      email: form.email.trim() || null,
      confirmacao: form.confirmacao,
      acompanhantes: Number(form.acompanhantes),
      restricao_alimentar: form.restricao_alimentar.trim() || null,
      observacoes: form.observacoes.trim() || null,
    }

    if (editingId.value) {
      await (client.from('vc_confirmacoes') as any).update(payload).eq('id', editingId.value)
    } else {
      await (client.from('vc_confirmacoes') as any).insert(payload)
    }

    closeModal()
    await load()
  } catch (err) {
    console.error('Erro ao salvar confirmação:', err)
  } finally {
    saving.value = false
  }
}

async function deleteConf(id: number) {
  if (!confirm('Deseja realmente remover esta confirmação de presença?')) return
  await (client.from('vc_confirmacoes') as any).delete().eq('id', id)
  await load()
}

function exportExcel() {
  const headers = ['Nome do Convidado', 'Contato / E-mail', 'Status', 'Acompanhantes', 'Restrição Alimentar', 'Observações', 'Data']
  const rows = confs.value.map(c => [
    c.nome || '',
    c.email || '',
    c.confirmacao === 'sim' ? 'Confirmado' : 'Não vai',
    c.acompanhantes || 0,
    c.restricao_alimentar || '',
    c.observacoes || '',
    formatDate(c.created_at),
  ])

  const tableHeader = headers.map(h => `<th style="background-color:#d4a020; color:#ffffff; font-weight:bold; padding:8px 12px; border:1px solid #dddddd; text-align:left;">${h}</th>`).join('')
  const tableRows = rows.map(row => {
    const cells = row.map(val => `<td style="padding:6px 12px; border:1px solid #eeeeee; vertical-align:middle;">${val}</td>`).join('')
    return `<tr>${cells}</tr>`
  }).join('')

  const excelContent = `
    <html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40">
      <head>
        <meta charset="utf-8" />
        <!--[if gte mso 9]>
        <xml>
          <x:ExcelWorkbook>
            <x:ExcelWorksheets>
              <x:ExcelWorksheet>
                <x:Name>Convidados</x:Name>
                <x:WorksheetOptions>
                  <x:DisplayGridlines/>
                </x:WorksheetOptions>
              </x:ExcelWorksheet>
            </x:ExcelWorksheets>
          </x:ExcelWorkbook>
        </xml>
        <![endif]-->
      </head>
      <body>
        <table border="1" style="border-collapse:collapse; font-family:Arial, sans-serif; font-size:14px;">
          <thead>
            <tr>${tableHeader}</tr>
          </thead>
          <tbody>
            ${tableRows}
          </tbody>
        </table>
      </body>
    </html>
  `

  const blob = new Blob(['\uFEFF' + excelContent], { type: 'application/vnd.ms-excel;charset=utf-8;' })
  const url  = URL.createObjectURL(blob)
  const a    = document.createElement('a')
  a.href = url
  a.download = 'lista_de_convidados_casamento.xls'
  a.click()
  URL.revokeObjectURL(url)
}
</script>

<style scoped>
.confirmacoes-admin { display: flex; flex-direction: column; gap: 24px; }

.page-actions-header {
  display: flex; justify-content: space-between; align-items: center; gap: 16px;
  flex-wrap: wrap;
}
.admin-page-title {
  font-size: 1.5rem; font-weight: 700; color: var(--admin-text); margin: 0 0 4px 0;
}
.admin-page-sub {
  font-size: 0.85rem; color: var(--admin-text-light); margin: 0;
}

.btn-add {
  padding: 12px 24px;
  background: linear-gradient(135deg, var(--rose-gold), var(--gold-medium));
  color: #fff; font-weight: 600; font-size: 0.88rem;
  border: none; border-radius: var(--radius-full);
  cursor: pointer; transition: var(--transition);
  box-shadow: 0 4px 14px rgba(201,150,125,0.3);
}
.btn-add:hover {
  transform: translateY(-1px);
  box-shadow: 0 6px 20px rgba(201,150,125,0.4);
}

.resumo-grid {
  display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px;
}
.resumo-card {
  background: var(--admin-card); border: 1px solid var(--admin-border);
  border-radius: var(--radius-md); padding: 20px;
  display: flex; flex-direction: column; align-items: center; gap: 6px;
  transition: var(--transition); text-align: center;
}
.resumo-card:hover { border-color: rgba(201,150,125,0.3); transform: translateY(-2px); }
.resumo-icon { font-size: 1.8rem; }
.resumo-num  { font-size: 2rem; font-weight: 700; color: var(--admin-text); }
.resumo-label{ font-size: 0.78rem; color: var(--admin-text-light); }

.search-row { display: flex; gap: 12px; align-items: center; }
.search-input {
  flex: 1; padding: 11px 16px;
  background: var(--admin-card); border: 1px solid var(--admin-border);
  border-radius: var(--radius-full); color: var(--admin-text);
  font-size: 0.875rem; outline: none; transition: var(--transition);
  font-family: var(--font-sans);
}
.search-input:focus { border-color: var(--rose-gold); }
.search-input::placeholder { color: var(--admin-text-light); }

.btn-export {
  padding: 11px 20px;
  background: rgba(201,150,125,0.1); border: 1px solid rgba(201,150,125,0.3);
  border-radius: var(--radius-full); color: var(--rose-gold-light);
  font-size: 0.82rem; font-weight: 500; transition: var(--transition); cursor: pointer;
  white-space: nowrap;
}
.btn-export:hover { background: rgba(201,150,125,0.2); }

.table-container { overflow-x: auto; }
.loading-state, .empty-state-big {
  display: flex; flex-direction: column; align-items: center; gap: 16px;
  min-height: 200px; justify-content: center;
  color: var(--admin-text-light); font-size: 0.9rem;
}
.empty-state-big span { font-size: 3rem; }

.conf-table {
  width: 100%; border-collapse: collapse;
  background: var(--admin-card); border-radius: var(--radius-md);
  overflow: hidden; border: 1px solid var(--admin-border);
}
.conf-table th {
  text-align: left; padding: 14px 16px;
  font-size: 0.72rem; font-weight: 600;
  letter-spacing: 0.08em; text-transform: uppercase;
  color: var(--admin-text-light); background: rgba(255,255,255,0.02);
  border-bottom: 1px solid var(--admin-border);
}
.conf-table th.th-actions { text-align: right; }
.conf-table td {
  padding: 14px 16px; font-size: 0.85rem;
  color: var(--admin-text-light);
  border-bottom: 1px solid var(--admin-border);
  vertical-align: middle;
}
.conf-table tr:last-child td { border-bottom: none; }
.conf-table tr:hover td { background: rgba(255,255,255,0.02); }
.td-nome  { color: var(--admin-text) !important; font-weight: 600; }
.td-email { font-size: 0.82rem !important; }
.td-restricao { font-size: 0.8rem !important; line-height: 1.4; }
.td-data  { font-size: 0.78rem !important; white-space: nowrap; }

.admin-badge {
  display: inline-block; padding: 4px 10px; border-radius: 12px;
  font-size: 0.75rem; font-weight: 600;
}
.badge-green { background: rgba(46, 204, 113, 0.15); color: #2ecc71; border: 1px solid rgba(46, 204, 113, 0.3); }
.badge-red   { background: rgba(231, 76, 60, 0.15); color: #e74c3c; border: 1px solid rgba(231, 76, 60, 0.3); }

.td-actions { display: flex; gap: 8px; justify-content: flex-end; align-items: center; }
.btn-action {
  padding: 6px 12px; border-radius: var(--radius-sm); font-size: 0.78rem;
  font-weight: 500; cursor: pointer; border: 1px solid transparent; transition: var(--transition);
}
.btn-action.edit {
  background: rgba(201,150,125,0.1); color: var(--rose-gold-light); border-color: rgba(201,150,125,0.3);
}
.btn-action.edit:hover { background: rgba(201,150,125,0.25); }
.btn-action.delete {
  background: rgba(231,76,60,0.1); color: #e74c3c; border-color: rgba(231,76,60,0.3);
}
.btn-action.delete:hover { background: rgba(231,76,60,0.25); }

/* Modal */
.modal-overlay {
  position: fixed; inset: 0; background: rgba(0,0,0,0.7);
  backdrop-filter: blur(8px); z-index: 1000;
  display: flex; align-items: center; justify-content: center; padding: 20px;
}
.modal-box {
  background: #1e1b18; border: 1px solid var(--admin-border);
  border-radius: var(--radius-lg); width: 100%; max-width: 520px;
  overflow: hidden; box-shadow: 0 20px 40px rgba(0,0,0,0.5);
  display: flex; flex-direction: column;
}
.modal-header {
  padding: 20px 24px; border-bottom: 1px solid var(--admin-border);
  display: flex; justify-content: space-between; align-items: center;
}
.modal-header h2 { font-size: 1.15rem; font-weight: 600; color: var(--admin-text); margin: 0; }
.modal-close {
  background: none; border: none; color: var(--admin-text-light);
  font-size: 1.2rem; cursor: pointer; padding: 4px;
}
.modal-close:hover { color: var(--admin-text); }

.modal-body { padding: 24px; display: flex; flex-direction: column; gap: 16px; }

.form-group { display: flex; flex-direction: column; gap: 6px; width: 100%; }
.form-group label {
  font-size: 0.72rem; font-weight: 600; letter-spacing: 0.06em;
  color: var(--admin-text-light); min-height: 16px; display: flex; align-items: center;
  white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
}
.form-group input, .form-group select {
  height: 42px; box-sizing: border-box; padding: 0 14px;
  background: rgba(255,255,255,0.04); border: 1px solid var(--admin-border);
  border-radius: var(--radius-sm); color: var(--admin-text);
  font-size: 0.88rem; outline: none; transition: var(--transition);
  font-family: var(--font-sans); width: 100%;
}
.form-group select option {
  background-color: #24201c;
  color: var(--admin-text);
  padding: 10px;
}
.form-group textarea {
  padding: 10px 14px; background: rgba(255,255,255,0.04);
  border: 1px solid var(--admin-border); border-radius: var(--radius-sm);
  color: var(--admin-text); font-size: 0.88rem; outline: none; transition: var(--transition);
  font-family: var(--font-sans); width: 100%; box-sizing: border-box; resize: vertical;
}
.form-group input:focus, .form-group select:focus, .form-group textarea:focus {
  border-color: var(--rose-gold); background: rgba(255,255,255,0.07);
}
.form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; align-items: start; }

.status-options { display: flex; gap: 12px; width: 100%; }
.status-option-btn {
  flex: 1; height: 44px; box-sizing: border-box;
  display: flex; align-items: center; justify-content: center;
  padding: 0 12px; border-radius: var(--radius-sm);
  border: 1px solid var(--admin-border); background: rgba(255,255,255,0.03);
  color: var(--admin-text-light); font-size: 0.84rem; font-weight: 500; cursor: pointer;
  transition: var(--transition); user-select: none;
}
.status-option-btn.active {
  background: rgba(46, 204, 113, 0.15); border-color: #2ecc71; color: #2ecc71; font-weight: 600;
}
.status-option-btn.red.active {
  background: rgba(231, 76, 60, 0.15); border-color: #e74c3c; color: #e74c3c; font-weight: 600;
}

.modal-footer {
  padding: 16px 24px; border-top: 1px solid var(--admin-border);
  display: flex; justify-content: flex-end; align-items: center; gap: 12px; background: rgba(0,0,0,0.2);
}
.btn-cancel {
  height: 42px; padding: 0 18px; background: transparent; border: 1px solid var(--admin-border);
  border-radius: var(--radius-sm); color: var(--admin-text-light); font-size: 0.84rem;
  font-weight: 500; cursor: pointer; transition: var(--transition);
  display: inline-flex; align-items: center; justify-content: center; box-sizing: border-box;
}
.btn-cancel:hover { background: rgba(255,255,255,0.05); color: var(--admin-text); }

.btn-save {
  height: 42px; padding: 0 22px;
  background: linear-gradient(135deg, var(--rose-gold), var(--gold-medium));
  border: none; border-radius: var(--radius-sm); color: #fff;
  font-size: 0.84rem; font-weight: 600; cursor: pointer; transition: var(--transition);
  display: inline-flex; align-items: center; justify-content: center; box-sizing: border-box;
}
.btn-save:hover { opacity: 0.9; transform: translateY(-1px); }
.btn-save:disabled { opacity: 0.5; cursor: not-allowed; }
</style>
