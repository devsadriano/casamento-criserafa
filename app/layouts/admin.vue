<template>
  <div class="admin-layout">
    <AdminSidebar />
    <div class="admin-main">
      <AdminTopbar />
      <main class="admin-content">
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
}
@media (max-width: 768px) {
  .admin-content { padding: 16px; }
}
</style>
