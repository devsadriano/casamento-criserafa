<template>
  <!-- Botão com todas as variantes do design system -->
  <component
    :is="tag"
    :href="href"
    :to="to"
    :type="tag === 'button' ? type : undefined"
    :disabled="disabled || loading"
    :class="classes"
    v-bind="$attrs"
  >
    <!-- Ícone esquerdo -->
    <span v-if="iconLeft" class="ds-btn__icon-left" aria-hidden="true">{{ iconLeft }}</span>
    <!-- Spinner de loading -->
    <span v-if="loading" class="ds-btn__spinner" aria-hidden="true">⟳</span>
    <!-- Conteúdo -->
    <span class="ds-btn__content">
      <slot />
    </span>
    <!-- Ícone direito -->
    <span v-if="iconRight && !loading" class="ds-btn__icon-right" aria-hidden="true">{{ iconRight }}</span>
  </component>
</template>

<script setup lang="ts">
/**
 * DsButton — Componente Botão do Design System
 *
 * Variantes: primary | secondary | ghost | danger | icon
 * Tamanhos:  sm | md | lg
 */
interface Props {
  variant?:  'primary' | 'secondary' | 'ghost' | 'danger' | 'icon'
  size?:     'sm' | 'md' | 'lg'
  type?:     'button' | 'submit' | 'reset'
  tag?:      'button' | 'a' | 'NuxtLink'
  href?:     string
  to?:       string
  disabled?: boolean
  loading?:  boolean
  iconLeft?: string
  iconRight?: string
  full?:     boolean
}

const props = withDefaults(defineProps<Props>(), {
  variant:  'primary',
  size:     'md',
  type:     'button',
  tag:      'button',
  disabled: false,
  loading:  false,
  full:     false,
})

const classes = computed(() => [
  'ds-btn',
  `ds-btn--${props.variant}`,
  `ds-btn--${props.size}`,
  { 'ds-btn--full':     props.full },
  { 'ds-btn--loading':  props.loading },
  { 'ds-btn--disabled': props.disabled },
])
</script>

<style scoped>
/* ── Base ── */
.ds-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  border: none;
  font-family: var(--font-sans);
  font-weight: 600;
  letter-spacing: 0.05em;
  text-transform: uppercase;
  cursor: pointer;
  transition: var(--transition);
  text-decoration: none;
  position: relative;
  overflow: hidden;
  white-space: nowrap;
  flex-shrink: 0;
}
.ds-btn--full { width: 100%; }
.ds-btn--disabled,
.ds-btn[disabled] {
  opacity: 0.5;
  cursor: not-allowed;
  pointer-events: none;
}

/* ── Tamanhos ── */
.ds-btn--sm {
  padding: 8px 18px;
  font-size: 0.75rem;
  border-radius: var(--radius-full);
}
.ds-btn--md {
  padding: 12px 28px;
  font-size: 0.85rem;
  border-radius: var(--radius-full);
}
.ds-btn--lg {
  padding: 16px 40px;
  font-size: 0.9rem;
  border-radius: var(--radius-full);
}

/* ── Primary ── */
.ds-btn--primary {
  background: linear-gradient(135deg, var(--sun-600) 0%, var(--sun-500) 50%, var(--gold-warm) 100%);
  color: var(--white);
  box-shadow: var(--shadow-gold);
}
.ds-btn--primary:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-gold-lg);
  filter: brightness(1.08);
}
.ds-btn--primary:active { transform: translateY(0); }

/* ── Secondary ── */
.ds-btn--secondary {
  background: transparent;
  color: var(--gold-medium);
  border: 1.5px solid var(--border-gold-hover);
}
.ds-btn--secondary:hover {
  background: var(--gold-pale);
  border-color: var(--gold);
  color: var(--gold);
  transform: translateY(-1px);
  box-shadow: var(--shadow-xs);
}

/* ── Ghost ── */
.ds-btn--ghost {
  background: rgba(232, 184, 75, 0.08);
  color: var(--gold-medium);
  border: 1px solid rgba(232, 184, 75, 0.15);
}
.ds-btn--ghost:hover {
  background: rgba(232, 184, 75, 0.15);
  color: var(--gold);
}

/* ── Danger ── */
.ds-btn--danger {
  background: rgba(239, 68, 68, 0.08);
  color: #dc2626;
  border: 1px solid rgba(239, 68, 68, 0.20);
}
.ds-btn--danger:hover {
  background: rgba(239, 68, 68, 0.14);
  border-color: rgba(239, 68, 68, 0.40);
}

/* ── Icon (circular) ── */
.ds-btn--icon {
  background: transparent;
  border: 1px solid var(--border-gold);
  color: var(--gold-medium);
  border-radius: 50%;
  padding: 0;
}
.ds-btn--icon.ds-btn--sm { width: 32px; height: 32px; }
.ds-btn--icon.ds-btn--md { width: 40px; height: 40px; }
.ds-btn--icon.ds-btn--lg { width: 52px; height: 52px; }
.ds-btn--icon:hover {
  background: var(--gold-pale);
  border-color: var(--gold);
  color: var(--gold);
  transform: scale(1.1);
}

/* ── Loading spinner ── */
.ds-btn__spinner {
  animation: spinSlow 0.8s linear infinite;
}
@keyframes spinSlow {
  to { transform: rotate(360deg); }
}
</style>
