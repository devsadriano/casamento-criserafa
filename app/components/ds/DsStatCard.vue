<template>
  <!-- DsStatCard — Card de Estatística do Admin -->
  <div class="ds-stat" v-bind="$attrs">
    <div class="ds-stat__icon">{{ icon }}</div>
    <div class="ds-stat__body">
      <div class="ds-stat__value">{{ value }}</div>
      <div class="ds-stat__label">{{ label }}</div>
    </div>
    <div v-if="trend" class="ds-stat__trend" :class="`ds-stat__trend--${trend}`">
      {{ trend === 'up' ? '↑' : '↓' }} {{ trendValue }}
    </div>
  </div>
</template>

<script setup lang="ts">
/**
 * DsStatCard — Card de Estatística para o Painel Admin
 */
interface Props {
  icon:        string
  value:       string | number
  label:       string
  trend?:      'up' | 'down'
  trendValue?: string
}

defineProps<Props>()
</script>

<style scoped>
.ds-stat {
  background: var(--bg-card);
  border: 1px solid var(--border-light);
  border-radius: var(--radius-lg);
  padding: 24px;
  display: flex;
  align-items: center;
  gap: 16px;
  box-shadow: var(--shadow-soft);
  transition: var(--transition);
  position: relative;
  overflow: hidden;
}
.ds-stat::after {
  content: '';
  position: absolute;
  bottom: 0; left: 0; right: 0;
  height: 3px;
  background: linear-gradient(to right, var(--sun-500), var(--gold-warm));
  opacity: 0;
  transition: opacity 0.3s;
}
.ds-stat:hover::after { opacity: 1; }
.ds-stat:hover {
  box-shadow: var(--shadow-card);
  border-color: var(--border-gold);
  transform: translateY(-2px);
}

.ds-stat__icon {
  width: 52px;
  height: 52px;
  border-radius: var(--radius-md);
  background: linear-gradient(135deg, var(--sun-100), var(--sun-200));
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
  flex-shrink: 0;
  border: 1px solid var(--border-gold);
}
.ds-stat__body { flex: 1; min-width: 0; }
.ds-stat__value {
  font-family: var(--font-serif);
  font-size: 2rem;
  color: var(--text-dark);
  font-weight: 600;
  line-height: 1;
}
.ds-stat__label {
  font-size: 0.72rem;
  color: var(--text-light);
  text-transform: uppercase;
  letter-spacing: 0.08em;
  margin-top: 6px;
}
.ds-stat__trend {
  font-size: 0.72rem;
  font-weight: 600;
  padding: 3px 8px;
  border-radius: var(--radius-full);
}
.ds-stat__trend--up   { background: rgba(34,197,94,0.1);  color: #16a34a; }
.ds-stat__trend--down { background: rgba(239,68,68,0.1);  color: #dc2626; }
</style>
