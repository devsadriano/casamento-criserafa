<template>
  <div class="mensagens-admin">
    <!-- Filtros -->
    <div class="filter-tabs">
      <button v-for="f in filters" :key="f.key" class="filter-tab" :class="{ active: activeFilter === f.key }" @click="activeFilter = f.key">
        {{ f.label }}
        <span class="filter-count">{{ (counts as any)[f.key] }}</span>
      </button>
    </div>

    <!-- Lista -->
    <div v-if="loading" class="loading-state">Carregando mensagens...</div>
    <div v-else-if="!filtered.length" class="empty-state-big">
      <span>💌</span>
      <p>Nenhuma mensagem nessa categoria.</p>
    </div>
    <div v-else class="mensagens-list">
      <div v-for="msg in filtered" :key="msg.id" class="msg-card" :class="{ aprovada: msg.aprovada }">
        <div class="msg-card-header">
          <div class="msg-card-info">
            <span class="msg-nome">{{ msg.nome }}</span>
            <span v-if="msg.relacao" class="msg-relacao">{{ msg.relacao }}</span>
            <span class="admin-badge" :class="msg.aprovada ? 'badge-green' : 'badge-yellow'">
              {{ msg.aprovada ? 'Aprovada' : 'Pendente' }}
            </span>
          </div>
          <span class="msg-data">{{ formatDate(msg.created_at) }}</span>
        </div>
        <div class="msg-texto">"{{ msg.mensagem }}"</div>
        <div class="msg-actions">
          <button v-if="!msg.aprovada" class="btn-aprovar" @click="aprovar(msg)">✅ Aprovar</button>
          <button v-if="msg.aprovada"  class="btn-rejeitar" @click="rejeitar(msg)">❌ Remover do mural</button>
          <button class="btn-excluir" @click="excluir(msg)">🗑️ Excluir</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({ layout: 'admin', middleware: ['admin'] })
useHead({ title: 'Mensagens — VouCasar Admin' })

const client = useSupabaseClient()
const loading = ref(true)
const mensagens = ref<any[]>([])
const activeFilter = ref('pendentes')

const filters = [
  { key: 'pendentes', label: '⏳ Pendentes' },
  { key: 'aprovadas', label: '✅ Aprovadas' },
  { key: 'todas',     label: '📋 Todas' },
]

const filtered = computed(() => {
  if (activeFilter.value === 'pendentes') return mensagens.value.filter(m => !m.aprovada)
  if (activeFilter.value === 'aprovadas') return mensagens.value.filter(m => m.aprovada)
  return mensagens.value
})

const counts = computed(() => ({
  pendentes: mensagens.value.filter(m => !m.aprovada).length,
  aprovadas: mensagens.value.filter(m =>  m.aprovada).length,
  todas:     mensagens.value.length,
}))

async function load() {
  loading.value = true
  const { data } = await (client.from('vc_mensagens') as any).select('*').order('created_at', { ascending: false })
  mensagens.value = data ?? []
  loading.value = false
}
await load()

async function aprovar(msg: any) {
  await (client.from('vc_mensagens') as any).update({ aprovada: true }).eq('id', msg.id)
  msg.aprovada = true
}
async function rejeitar(msg: any) {
  await (client.from('vc_mensagens') as any).update({ aprovada: false }).eq('id', msg.id)
  msg.aprovada = false
}
async function excluir(msg: any) {
  if (!confirm('Excluir esta mensagem permanentemente?')) return
  await (client.from('vc_mensagens') as any).delete().eq('id', msg.id)
  mensagens.value = mensagens.value.filter(m => m.id !== msg.id)
}

function formatDate(d: string) {
  return new Date(d).toLocaleDateString('pt-BR', { day: '2-digit', month: 'short', year: 'numeric' })
}
</script>

<style scoped>
.mensagens-admin { display: flex; flex-direction: column; gap: 24px; }

.filter-tabs { display: flex; gap: 8px; }
.filter-tab {
  display: flex; align-items: center; gap: 8px;
  padding: 9px 18px;
  background: var(--admin-card); border: 1px solid var(--admin-border);
  border-radius: var(--radius-full); color: var(--admin-text-light);
  font-size: 0.82rem; font-weight: 500; transition: var(--transition); cursor: pointer;
}
.filter-tab.active { border-color: var(--rose-gold); color: var(--rose-gold-light); background: rgba(201,150,125,0.08); }
.filter-count {
  background: rgba(255,255,255,0.08); padding: 1px 8px;
  border-radius: var(--radius-full); font-size: 0.72rem;
}

.loading-state, .empty-state-big {
  display: flex; flex-direction: column; align-items: center; gap: 16px;
  min-height: 200px; justify-content: center;
  color: var(--admin-text-light); font-size: 0.9rem;
}
.empty-state-big span { font-size: 3rem; }

.mensagens-list { display: flex; flex-direction: column; gap: 12px; }

.msg-card {
  background: var(--admin-card); border: 1px solid var(--admin-border);
  border-radius: var(--radius-md); padding: 20px;
  transition: var(--transition);
}
.msg-card.aprovada { border-left: 3px solid #22c55e; }
.msg-card-header {
  display: flex; align-items: flex-start; justify-content: space-between;
  margin-bottom: 12px; gap: 12px;
}
.msg-card-info { display: flex; align-items: center; flex-wrap: wrap; gap: 8px; }
.msg-nome { font-weight: 600; color: var(--admin-text); font-size: 0.9rem; }
.msg-relacao {
  font-size: 0.75rem; color: var(--admin-text-light);
  background: rgba(255,255,255,0.06); padding: 2px 8px; border-radius: var(--radius-full);
}
.msg-data { font-size: 0.72rem; color: var(--admin-text-light); white-space: nowrap; }

.msg-texto {
  font-size: 0.9rem; color: var(--admin-text-light);
  line-height: 1.7; font-style: italic; margin-bottom: 16px;
  padding: 12px 16px; background: rgba(255,255,255,0.03);
  border-radius: var(--radius-sm); border-left: 2px solid rgba(201,150,125,0.3);
}

.msg-actions { display: flex; gap: 8px; flex-wrap: wrap; }
.btn-aprovar, .btn-rejeitar, .btn-excluir {
  padding: 7px 16px; border-radius: var(--radius-full);
  font-size: 0.78rem; font-weight: 500; transition: var(--transition); cursor: pointer;
  border: 1px solid;
}
.btn-aprovar  { background: rgba(34,197,94,0.1); border-color: rgba(34,197,94,0.3); color: #86efac; }
.btn-aprovar:hover  { background: rgba(34,197,94,0.2); }
.btn-rejeitar { background: rgba(234,179,8,0.1);  border-color: rgba(234,179,8,0.3);  color: #fde047; }
.btn-rejeitar:hover { background: rgba(234,179,8,0.2); }
.btn-excluir  { background: rgba(239,68,68,0.1);  border-color: rgba(239,68,68,0.3);  color: #fca5a5; }
.btn-excluir:hover  { background: rgba(239,68,68,0.2); }
</style>
