<template>
  <aside class="sidebar" :class="{ open: sidebarOpen }">
    <!-- Header -->
    <div class="sidebar-header">
      <div class="sidebar-brand">
        <span class="brand-icon">💍</span>
        <div>
          <div class="brand-name">VouCasar</div>
          <div class="brand-sub">Painel dos Noivos</div>
        </div>
      </div>
      <button class="sidebar-close-btn" @click="sidebarOpen = false">✕</button>
    </div>

    <!-- Nav -->
    <nav class="sidebar-nav">
      <div class="sidebar-section-label">Geral</div>
      <NuxtLink to="/admin/dashboard" class="sidebar-link" @click="sidebarOpen = false">
        <span class="sidebar-icon">📊</span>
        Dashboard
      </NuxtLink>

      <div class="sidebar-section-label">Conteúdo</div>
      <NuxtLink to="/admin/presentes" class="sidebar-link" @click="sidebarOpen = false">
        <span class="sidebar-icon">🎁</span>
        Lista de Presentes
      </NuxtLink>
      <NuxtLink to="/admin/galeria" class="sidebar-link" @click="sidebarOpen = false">
        <span class="sidebar-icon">📸</span>
        Galeria de Fotos
      </NuxtLink>
      <NuxtLink to="/admin/mensagens" class="sidebar-link" @click="sidebarOpen = false">
        <span class="sidebar-icon">💌</span>
        Mural de Mensagens
        <span v-if="pendingCount > 0" class="sidebar-badge">{{ pendingCount }}</span>
      </NuxtLink>
      <NuxtLink to="/admin/confirmacoes" class="sidebar-link" @click="sidebarOpen = false">
        <span class="sidebar-icon">✅</span>
        Confirmações RSVP
      </NuxtLink>
    </nav>

    <!-- Footer -->
    <div class="sidebar-footer">
      <NuxtLink to="/" target="_blank" class="sidebar-footer-link">
        <span>↗</span> Ver site do casal
      </NuxtLink>
      <button class="sidebar-logout-btn" @click="handleLogout">
        <span>⬡</span> Sair do painel
      </button>
    </div>
  </aside>

  <!-- Mobile overlay -->
  <div v-if="sidebarOpen" class="sidebar-overlay" @click="sidebarOpen = false" />
</template>

<script setup lang="ts">
const client = useSupabaseClient()
const router = useRouter()

const sidebarOpen = useState('sidebarOpen', () => false)

// Buscar mensagens pendentes
const { data: pending } = await useAsyncData('pending-msgs', async () => {
  const { count } = await client
    .from('vc_mensagens')
    .select('*', { count: 'exact', head: true })
    .eq('aprovada', false)
  return count ?? 0
})
const pendingCount = computed(() => pending.value ?? 0)

async function handleLogout() {
  await client.auth.signOut()
  router.push('/admin/login')
}
</script>

<style scoped>
.sidebar {
  width: 260px;
  min-height: 100vh;
  background: var(--admin-sidebar);
  border-right: 1px solid var(--admin-border);
  display: flex;
  flex-direction: column;
  position: sticky;
  top: 0;
  transition: transform 0.3s ease;
  z-index: 100;
}

.sidebar-header {
  padding: 24px 20px;
  border-bottom: 1px solid var(--admin-border);
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.sidebar-brand {
  display: flex;
  align-items: center;
  gap: 12px;
}
.brand-icon {
  font-size: 1.5rem;
}
.brand-name {
  font-family: var(--font-serif);
  font-size: 1.1rem;
  color: var(--rose-gold-light);
  font-weight: 600;
}
.brand-sub {
  font-size: 0.7rem;
  color: var(--admin-text-light);
  letter-spacing: 0.05em;
}
.sidebar-close-btn {
  display: none;
  color: var(--admin-text-light);
  font-size: 1rem;
  cursor: pointer;
}

.sidebar-nav {
  flex: 1;
  padding: 20px 12px;
  display: flex;
  flex-direction: column;
  gap: 2px;
}
.sidebar-section-label {
  font-size: 0.65rem;
  font-weight: 600;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  color: var(--admin-text-light);
  padding: 12px 8px 6px;
}
.sidebar-link {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 12px;
  border-radius: var(--radius-sm);
  color: var(--admin-text-light);
  font-size: 0.875rem;
  font-weight: 400;
  transition: var(--transition);
  position: relative;
  text-decoration: none;
}
.sidebar-link:hover {
  background: rgba(255,255,255,0.06);
  color: var(--admin-text);
}
.sidebar-link.router-link-active {
  background: rgba(201, 150, 125, 0.12);
  color: var(--rose-gold-light);
}
.sidebar-icon {
  font-size: 1rem;
}
.sidebar-badge {
  margin-left: auto;
  background: var(--rose-gold);
  color: white;
  font-size: 0.65rem;
  font-weight: 700;
  padding: 2px 7px;
  border-radius: var(--radius-full);
}

.sidebar-footer {
  padding: 16px 12px;
  border-top: 1px solid var(--admin-border);
  display: flex;
  flex-direction: column;
  gap: 6px;
}
.sidebar-footer-link,
.sidebar-logout-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 9px 12px;
  border-radius: var(--radius-sm);
  font-size: 0.8rem;
  color: var(--admin-text-light);
  transition: var(--transition);
  text-decoration: none;
  width: 100%;
  text-align: left;
}
.sidebar-footer-link:hover { color: var(--rose-gold-light); background: rgba(255,255,255,0.04); }
.sidebar-logout-btn:hover  { color: #ef4444; background: rgba(239,68,68,0.08); }

.sidebar-overlay {
  display: none;
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.5);
  z-index: 99;
}

@media (max-width: 900px) {
  .sidebar {
    position: fixed;
    left: 0;
    top: 0;
    height: 100vh;
    transform: translateX(-100%);
  }
  .sidebar.open {
    transform: translateX(0);
    box-shadow: 4px 0 24px rgba(0,0,0,0.5);
  }
  .sidebar-close-btn { display: flex; }
  .sidebar-overlay { display: block; }
}
</style>
