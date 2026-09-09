<template>
  <header class="admin-topbar">
    <!-- Mobile menu toggle -->
    <button class="topbar-menu-btn" @click="sidebarOpen = !sidebarOpen">
      <span></span><span></span><span></span>
    </button>

    <!-- Page title -->
    <div class="topbar-title">
      <h1>{{ title }}</h1>
      <p v-if="subtitle">{{ subtitle }}</p>
    </div>

    <!-- User info -->
    <div class="topbar-user">
      <span class="topbar-user-avatar">💍</span>
      <span class="topbar-user-name">Cristina & Rafael</span>
    </div>
  </header>
</template>

<script setup lang="ts">
const route = useRoute()
const sidebarOpen = useState('sidebarOpen', () => false)

const pageMap: Record<string, { title: string; subtitle: string }> = {
  '/admin/dashboard':    { title: 'Dashboard',           subtitle: 'Visão geral do seu casamento' },
  '/admin/presentes':    { title: 'Lista de Presentes',  subtitle: 'Gerencie os presentes do casal' },
  '/admin/galeria':      { title: 'Galeria de Fotos',    subtitle: 'Upload e organização das fotos' },
  '/admin/mensagens':    { title: 'Mural de Mensagens',  subtitle: 'Modere os recados dos convidados' },
  '/admin/confirmacoes': { title: 'Confirmações RSVP',   subtitle: 'Lista de presença dos convidados' },
}

const current = computed(() => pageMap[route.path] ?? { title: 'Admin', subtitle: '' })
const title    = computed(() => current.value.title)
const subtitle = computed(() => current.value.subtitle)
</script>

<style scoped>
.admin-topbar {
  height: 68px;
  background: var(--admin-sidebar);
  border-bottom: 1px solid var(--admin-border);
  display: flex;
  align-items: center;
  padding: 0 32px;
  gap: 16px;
  position: sticky;
  top: 0;
  z-index: 50;
}

.topbar-menu-btn {
  display: none;
  flex-direction: column;
  gap: 5px;
  cursor: pointer;
  padding: 4px;
}
.topbar-menu-btn span {
  display: block;
  width: 22px;
  height: 2px;
  background: var(--admin-text-light);
  border-radius: 2px;
  transition: var(--transition);
}

.topbar-title {
  flex: 1;
}
.topbar-title h1 {
  font-size: 1.1rem;
  font-weight: 600;
  color: var(--admin-text);
  line-height: 1.2;
}
.topbar-title p {
  font-size: 0.75rem;
  color: var(--admin-text-light);
  margin-top: 2px;
}

.topbar-user {
  display: flex;
  align-items: center;
  gap: 10px;
}
.topbar-user-avatar {
  width: 36px;
  height: 36px;
  background: rgba(201,150,125,0.12);
  border-radius: var(--radius-full);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1rem;
}
.topbar-user-name {
  font-size: 0.85rem;
  color: var(--admin-text-light);
  font-family: var(--font-serif);
  display: none;
}

@media (min-width: 901px) {
  .topbar-user-name { display: block; }
}
@media (max-width: 900px) {
  .admin-topbar { padding: 0 16px; }
  .topbar-menu-btn { display: flex; }
}
</style>
