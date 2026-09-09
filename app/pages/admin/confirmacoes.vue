<template>
  <div class="confirmacoes-admin">
    <!-- Resumo -->
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
        <div class="resumo-label">Total de Pessoas</div>
      </div>
    </div>

    <!-- Filtro de busca -->
    <div class="search-row">
      <input v-model="search" type="text" placeholder="🔍 Buscar por nome ou e-mail..." class="search-input" />
      <button class="btn-export" @click="exportCSV">⬇️ Exportar CSV</button>
    </div>

    <!-- Tabela -->
    <div class="table-container">
      <div v-if="loading" class="loading-state">Carregando confirmações...</div>
      <div v-else-if="!filtered.length" class="empty-state-big">
        <span>🥂</span>
        <p>Nenhuma confirmação ainda.</p>
      </div>
      <table v-else class="conf-table">
        <thead>
          <tr>
            <th>Nome</th>
            <th>E-mail</th>
            <th>Status</th>
            <th>Acompanhantes</th>
            <th>Restrição Alimentar</th>
            <th>Data</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="conf in filtered" :key="conf.id">
            <td class="td-nome">{{ conf.nome }}</td>
            <td class="td-email">{{ conf.email }}</td>
            <td>
              <span class="admin-badge" :class="conf.confirmacao === 'sim' ? 'badge-green' : 'badge-red'">
                {{ conf.confirmacao === 'sim' ? 'Confirmado' : 'Não vai' }}
              </span>
            </td>
            <td>{{ conf.acompanhantes }} acomp.</td>
            <td class="td-restricao">{{ conf.restricao_alimentar || '—' }}</td>
            <td class="td-data">{{ formatDate(conf.created_at) }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({ layout: 'admin', middleware: ['admin'] })
useHead({ title: 'Confirmações — VouCasar Admin' })

const client  = useSupabaseClient()
const loading = ref(true)
const confs   = ref<any[]>([])
const search  = ref('')

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
    c.nome.toLowerCase().includes(q) ||
    c.email.toLowerCase().includes(q)
  )
})

const confirmados   = computed(() => confs.value.filter(c => c.confirmacao === 'sim').length)
const naoVao        = computed(() => confs.value.filter(c => c.confirmacao !== 'sim').length)
const totalPessoas  = computed(() =>
  confs.value.filter(c => c.confirmacao === 'sim')
             .reduce((acc, c) => acc + 1 + (c.acompanhantes ?? 0), 0)
)

function formatDate(d: string) {
  return new Date(d).toLocaleDateString('pt-BR', { day: '2-digit', month: '2-digit', year: 'numeric' })
}

function exportCSV() {
  const headers = ['Nome', 'Email', 'Status', 'Acompanhantes', 'Restricao Alimentar', 'Data']
  const rows = confs.value.map(c => [
    c.nome, c.email,
    c.confirmacao === 'sim' ? 'Confirmado' : 'Não vai',
    c.acompanhantes,
    c.restricao_alimentar ?? '',
    formatDate(c.created_at),
  ])
  const csv = [headers, ...rows].map(r => r.map(v => `"${v}"`).join(',')).join('\n')
  const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' })
  const url  = URL.createObjectURL(blob)
  const a    = document.createElement('a')
  a.href = url; a.download = 'confirmacoes.csv'; a.click()
  URL.revokeObjectURL(url)
}
</script>

<style scoped>
.confirmacoes-admin { display: flex; flex-direction: column; gap: 24px; }

.resumo-grid {
  display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px;
}
.resumo-card {
  background: var(--admin-card); border: 1px solid var(--admin-border);
  border-radius: var(--radius-md); padding: 20px;
  display: flex; flex-direction: column; align-items: center; gap: 6px;
  transition: var(--transition);
}
.resumo-card:hover { border-color: rgba(201,150,125,0.2); transform: translateY(-2px); }
.resumo-icon { font-size: 1.8rem; }
.resumo-num  { font-size: 2rem; font-weight: 700; color: var(--admin-text); }
.resumo-label{ font-size: 0.75rem; color: var(--admin-text-light); }

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
  text-align: left; padding: 12px 16px;
  font-size: 0.72rem; font-weight: 600;
  letter-spacing: 0.08em; text-transform: uppercase;
  color: var(--admin-text-light); background: rgba(255,255,255,0.02);
  border-bottom: 1px solid var(--admin-border);
}
.conf-table td {
  padding: 12px 16px; font-size: 0.85rem;
  color: var(--admin-text-light);
  border-bottom: 1px solid var(--admin-border);
}
.conf-table tr:last-child td { border-bottom: none; }
.conf-table tr:hover td { background: rgba(255,255,255,0.02); }
.td-nome  { color: var(--admin-text) !important; font-weight: 500; }
.td-email { font-size: 0.8rem !important; }
.td-restricao { font-size: 0.78rem !important; }
.td-data  { font-size: 0.78rem !important; white-space: nowrap; }
</style>
