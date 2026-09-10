<template>
  <div class="admin-layout">
    <AdminSidebar />
    <div class="admin-main">
      <AdminTopbar />
      <main class="admin-content">
        <!-- Decoração sutil de girassol no admin -->
        <div class="admin-sunflower-deco" aria-hidden="true">🌻</div>
        <slot />
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import AdminSidebar from '~/components/admin/AdminSidebar.vue'
import AdminTopbar from '~/components/admin/AdminTopbar.vue'
</script>

<style>
.admin-layout {
  display: flex;
  min-height: 100vh;
  background: var(--admin-bg);
  color: var(--admin-text);
  font-family: var(--font-sans);
}
.admin-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-width: 0;
  overflow: hidden;
}
.admin-content {
  flex: 1;
  padding: 32px;
  overflow-y: auto;
  position: relative;
}
.admin-sunflower-deco {
  position: fixed;
  right: -60px;
  bottom: -60px;
  font-size: 18rem;
  opacity: 0.025;
  pointer-events: none;
  z-index: 0;
  transform: rotate(-20deg);
  line-height: 1;
  user-select: none;
}
@media (max-width: 768px) {
  .admin-content { padding: 16px; }
}
</style>
