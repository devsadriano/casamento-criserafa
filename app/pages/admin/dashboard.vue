<template>
  <div class="dashboard">
    <!-- Stats Grid -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-icon" style="background: rgba(201,150,125,0.15);">🎁</div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.presentes }}</div>
          <div class="stat-label">Presentes Cadastrados</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background: rgba(34,197,94,0.15);">✅</div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.confirmados }}</div>
          <div class="stat-label">Pessoas Confirmadas</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background: rgba(59,130,246,0.15);">💌</div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.mensagens }}</div>
          <div class="stat-label">Mensagens no Mural</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background: rgba(234,179,8,0.15);">📸</div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.fotos }}</div>
          <div class="stat-label">Fotos na Galeria</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background: rgba(168,85,247,0.15);">⏳</div>
        <div class="stat-info">
          <div class="stat-value">{{ stats.dias }}</div>
          <div class="stat-label">Dias para o Grande Dia</div>
        </div>
      </div>
    </div>

    <!-- Cards Row -->
    <div class="dashboard-row">
      <!-- Mensagens pendentes -->
      <div class="admin-card">
        <div class="admin-card-header">
          <div class="admin-card-title">💌 Mensagens Pendentes</div>
          <NuxtLink to="/admin/mensagens" class="admin-card-action">Ver todas →</NuxtLink>
        </div>
        <div class="admin-card-body">
          <div v-if="!mensagensPendentes?.length" class="empty-state">
            <span>✨ Nenhuma mensagem pendente!</span>
          </div>
          <div v-for="msg in mensagensPendentes" :key="msg.id" class="msg-preview">
            <div class="msg-preview-name">{{ msg.nome }}
              <span v-if="msg.relacao" class="msg-preview-rel">· {{ msg.relacao }}</span>
            </div>
            <div class="msg-preview-text">{{ msg.mensagem.slice(0, 80) }}{{ msg.mensagem.length > 80 ? '...' : '' }}</div>
          </div>
        </div>
      </div>

      <!-- Últimas confirmações -->
      <div class="admin-card">
        <div class="admin-card-header">
          <div class="admin-card-title">✅ Últimas Confirmações</div>
          <NuxtLink to="/admin/confirmacoes" class="admin-card-action">Ver todas →</NuxtLink>
        </div>
        <div class="admin-card-body">
          <div v-if="!ultimasConf?.length" class="empty-state">
            <span>Nenhuma confirmação ainda</span>
          </div>
          <div v-for="conf in ultimasConf" :key="conf.id" class="conf-preview">
            <div class="conf-preview-left">
              <div class="conf-preview-name">{{ conf.nome }}</div>
              <div class="conf-preview-info">{{ conf.acompanhantes }} acompanhante(s)</div>
            </div>
            <span class="admin-badge" :class="conf.confirmacao === 'sim' ? 'badge-green' : 'badge-red'">
              {{ conf.confirmacao === 'sim' ? 'Confirmado' : 'Não vai' }}
            </span>
          </div>
        </div>
      </div>
    </div>

    <!-- Quick Actions -->
    <div class="admin-card">
      <div class="admin-card-header">
        <div class="admin-card-title">⚡ Ações Rápidas</div>
      </div>
      <div class="admin-card-body">
        <div class="quick-actions">
          <NuxtLink to="/admin/presentes" class="quick-btn">
            <span>🎁</span> Adicionar Presente
          </NuxtLink>
          <NuxtLink to="/admin/galeria" class="quick-btn">
            <span>📸</span> Upload de Fotos
          </NuxtLink>
          <NuxtLink to="/admin/mensagens" class="quick-btn">
            <span>💌</span> Moderar Mensagens
          </NuxtLink>
          <NuxtLink to="/" target="_blank" class="quick-btn">
            <span>↗</span> Ver Site Público
          </NuxtLink>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  layout: 'admin',
  middleware: ['admin'],
})

useHead({ title: 'Dashboard — VouCasar Admin' })

const client = useSupabaseClient()

const [presentes, confirmacoes, mensagens, galeria, pendentes] = await Promise.all([
  (client.from('vc_presentes') as any).select('*', { count: 'exact', head: true }),
  (client.from('vc_confirmacoes') as any).select('*', { count: 'exact', head: true }).eq('confirmacao', 'sim'),
  (client.from('vc_mensagens') as any).select('*', { count: 'exact', head: true }).eq('aprovada', true),
  (client.from('vc_galeria') as any).select('*', { count: 'exact', head: true }),
  (client.from('vc_mensagens') as any).select('id,nome,relacao,mensagem').eq('aprovada', false).order('created_at', { ascending: false }).limit(3),
])

const { data: ultimasConfRaw } = await (client.from('vc_confirmacoes') as any)
  .select('id,nome,confirmacao,acompanhantes')
  .order('created_at', { ascending: false })
  .limit(5)

type MsgPendente = { id: number; nome: string; relacao: string | null; mensagem: string }
type UltimaConf  = { id: number; nome: string; confirmacao: string; acompanhantes: number }

const ultimasConf        = (ultimasConfRaw ?? []) as UltimaConf[]
const mensagensPendentes = (pendentes.data ?? []) as MsgPendente[]

// Calcular dias restantes
const weddingDate = new Date('2027-06-19T17:30:00')
const today = new Date()
const diffDays = Math.ceil((weddingDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24))

const stats = {
  presentes:   presentes.count ?? 0,
  confirmados: confirmacoes.count ?? 0,
  mensagens:   mensagens.count ?? 0,
  fotos:       galeria.count ?? 0,
  dias:        diffDays > 0 ? diffDays : 0,
}
</script>

<style scoped>
.dashboard { display: flex; flex-direction: column; gap: 24px; }

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 16px;
}

.stat-card {
  background: var(--admin-card);
  border: 1px solid var(--admin-border);
  border-radius: var(--radius-md);
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 16px;
  transition: var(--transition);
}
.stat-card:hover {
  border-color: rgba(232, 184, 75, 0.25);
  transform: translateY(-2px);
}
.stat-icon {
  width: 48px; height: 48px;
  border-radius: var(--radius-sm);
  display: flex; align-items: center; justify-content: center;
  font-size: 1.3rem;
  flex-shrink: 0;
}
.stat-value {
  font-size: 1.6rem;
  font-weight: 700;
  color: var(--admin-text);
  line-height: 1;
}
.stat-label {
  font-size: 0.75rem;
  color: var(--admin-text-light);
  margin-top: 4px;
}

.dashboard-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 24px;
}
@media (max-width: 768px) {
  .dashboard-row { grid-template-columns: 1fr; }
}

.admin-card {
  background: var(--admin-card);
  border: 1px solid var(--admin-border);
  border-radius: var(--radius-md);
  overflow: hidden;
}
.admin-card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 20px;
  border-bottom: 1px solid var(--admin-border);
}
.admin-card-title {
  font-size: 0.9rem;
  font-weight: 600;
  color: var(--admin-text);
}
.admin-card-action {
  font-size: 0.75rem;
  color: var(--gold-light);
  text-decoration: none;
  transition: var(--transition);
}
.admin-card-action:hover { color: var(--gold); }
.admin-card-body {
  padding: 16px 20px;
  display: flex;
  flex-direction: column;
  gap: 12px;
  min-height: 100px;
}

.empty-state {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 80px;
  color: var(--admin-text-light);
  font-size: 0.85rem;
}

.msg-preview {
  padding: 10px 12px;
  background: rgba(255,255,255,0.03);
  border-radius: var(--radius-sm);
  border: 1px solid var(--admin-border);
}
.msg-preview-name {
  font-size: 0.8rem;
  font-weight: 600;
  color: var(--admin-text);
  margin-bottom: 4px;
}
.msg-preview-rel {
  font-weight: 400;
  color: var(--admin-text-light);
}
.msg-preview-text {
  font-size: 0.78rem;
  color: var(--admin-text-light);
  line-height: 1.5;
}

.conf-preview {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8px 12px;
  border-radius: var(--radius-sm);
  background: rgba(255,255,255,0.03);
  border: 1px solid var(--admin-border);
}
.conf-preview-name {
  font-size: 0.85rem;
  color: var(--admin-text);
  font-weight: 500;
}
.conf-preview-info {
  font-size: 0.72rem;
  color: var(--admin-text-light);
  margin-top: 2px;
}

.quick-actions {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
  gap: 12px;
}
.quick-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 16px;
  background: rgba(255,255,255,0.04);
  border: 1px solid var(--admin-border);
  border-radius: var(--radius-sm);
  color: var(--admin-text-light);
  font-size: 0.85rem;
  text-decoration: none;
  transition: var(--transition);
  cursor: pointer;
}
.quick-btn:hover {
  background: rgba(232, 184, 75, 0.08);
  border-color: rgba(232, 184, 75, 0.30);
  color: var(--gold-light);
}
</style>
