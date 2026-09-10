<template>
  <!-- DsBadge — Badge/Tag do Design System -->
  <span :class="classes" v-bind="$attrs">
    <span v-if="icon" class="ds-badge__icon" aria-hidden="true">{{ icon }}</span>
    <slot />
  </span>
</template>

<script setup lang="ts">
/**
 * DsBadge — Componente Badge do Design System
 *
 * Cores: gold | green | yellow | red | blue | gray
 */
interface Props {
  color?: 'gold' | 'green' | 'yellow' | 'red' | 'blue' | 'gray' | 'dark'
  size?:  'sm' | 'md'
  icon?:  string
}

const props = withDefaults(defineProps<Props>(), {
  color: 'gold',
  size:  'md',
})

const classes = computed(() => [
  'ds-badge',
  `ds-badge--${props.color}`,
  `ds-badge--${props.size}`,
])
</script>

<style scoped>
.ds-badge {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  border-radius: var(--radius-full);
  font-weight: 600;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  white-space: nowrap;
}

/* Tamanhos */
.ds-badge--sm { font-size: 0.62rem; padding: 2px 8px; }
.ds-badge--md { font-size: 0.7rem;  padding: 4px 12px; }

/* Cores */
.ds-badge--gold   { background: rgba(232,184,75,0.15); color: var(--gold);   border: 1px solid rgba(232,184,75,0.28); }
.ds-badge--green  { background: rgba(34,197,94,0.12);  color: #16a34a;       border: 1px solid rgba(34,197,94,0.25); }
.ds-badge--yellow { background: rgba(234,179,8,0.12);  color: #ca8a04;       border: 1px solid rgba(234,179,8,0.25); }
.ds-badge--red    { background: rgba(239,68,68,0.12);  color: #dc2626;       border: 1px solid rgba(239,68,68,0.25); }
.ds-badge--blue   { background: rgba(59,130,246,0.12); color: #2563eb;       border: 1px solid rgba(59,130,246,0.25); }
.ds-badge--gray   { background: rgba(156,163,175,0.12); color: #6b7280;      border: 1px solid rgba(156,163,175,0.25); }
.ds-badge--dark   { background: rgba(232,184,75,0.12); color: var(--gold-light); border: 1px solid rgba(232,184,75,0.15); }
</style>
