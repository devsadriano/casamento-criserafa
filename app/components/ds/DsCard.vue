<template>
  <!-- DsCard — Card base do Design System -->
  <div :class="classes" v-bind="$attrs">
    <!-- Slot padrão -->
    <slot />
  </div>
</template>

<script setup lang="ts">
/**
 * DsCard — Componente Card do Design System
 *
 * Variantes: default | glass | sunflower | flat
 * Hover opcional
 */
interface Props {
  variant?: 'default' | 'glass' | 'sunflower' | 'flat' | 'dark'
  hover?:   boolean
  padding?: 'none' | 'sm' | 'md' | 'lg'
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'default',
  hover:   true,
  padding: 'md',
})

const classes = computed(() => [
  'ds-card',
  `ds-card--${props.variant}`,
  `ds-card--pad-${props.padding}`,
  { 'ds-card--hover': props.hover },
])
</script>

<style scoped>
/* ── Base ── */
.ds-card {
  border-radius: var(--radius-lg);
  border: 1px solid var(--border-light);
  transition: var(--transition);
  position: relative;
  overflow: hidden;
}

/* Padding */
.ds-card--pad-none { padding: 0; }
.ds-card--pad-sm   { padding: 16px; }
.ds-card--pad-md   { padding: 28px; }
.ds-card--pad-lg   { padding: 40px; }

/* ── Hover ── */
.ds-card--hover:hover {
  transform: translateY(-3px);
  box-shadow: var(--shadow-card);
  border-color: var(--border-gold);
}

/* ── Default ── */
.ds-card--default {
  background: var(--bg-card);
  box-shadow: var(--shadow-soft);
}

/* ── Glass ── */
.ds-card--glass {
  background: rgba(255, 253, 240, 0.88);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border-color: rgba(232, 184, 75, 0.18);
  box-shadow: var(--shadow-soft);
}

/* ── Sunflower ── */
.ds-card--sunflower {
  background: var(--cream-100);
  border-color: var(--border-gold);
  box-shadow: var(--shadow-soft);
}
.ds-card--sunflower::before {
  content: '🌻';
  position: absolute;
  right: -8px;
  bottom: -8px;
  font-size: 5rem;
  opacity: 0.05;
  transform: rotate(15deg);
  pointer-events: none;
  line-height: 1;
}

/* ── Flat ── */
.ds-card--flat {
  background: var(--cream-100);
  border-color: var(--border-light);
  box-shadow: none;
}

/* ── Dark (Admin) ── */
.ds-card--dark {
  background: var(--admin-card);
  border-color: var(--admin-border);
  box-shadow: none;
  color: var(--admin-text);
}
.ds-card--dark:hover {
  background: var(--admin-card-hover);
  border-color: var(--admin-border-hover);
}
</style>
