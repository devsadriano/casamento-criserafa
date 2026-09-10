<template>
  <!-- DsSectionHeader — Cabeçalho padronizado de seção -->
  <div class="ds-section-header" :class="{ 'ds-section-header--light': light }">
    <span v-if="tag" class="ds-section-header__tag">{{ tag }}</span>
    <h2 v-if="title" class="ds-section-header__title font-script">{{ title }}</h2>
    <slot name="title" />
    <div v-if="divider" class="ds-section-header__divider">
      <span class="ds-section-header__divider-icon">{{ dividerIcon }}</span>
    </div>
    <p v-if="subtitle" class="ds-section-header__sub">{{ subtitle }}</p>
    <slot />
  </div>
</template>

<script setup lang="ts">
/**
 * DsSectionHeader — Cabeçalho de Seção Padrão
 * Usado em todas as seções para manter consistência visual.
 */
interface Props {
  tag?:         string   // Ex: "✦ Sobre Nós"
  title?:       string   // Título principal (script font)
  subtitle?:    string   // Subtítulo abaixo do divisor
  divider?:     boolean  // Mostrar divisor decorativo
  dividerIcon?: string   // Ícone central do divisor
  light?:       boolean  // Modo claro (para seções escuras)
}

withDefaults(defineProps<Props>(), {
  divider:     true,
  dividerIcon: '✦',
  light:       false,
})
</script>

<style scoped>
.ds-section-header {
  text-align: center;
  margin-bottom: 56px;
}

.ds-section-header__tag {
  font-family: var(--font-sans);
  font-size: 0.72rem;
  font-weight: 600;
  letter-spacing: 0.22em;
  text-transform: uppercase;
  color: var(--gold-medium);
  display: block;
  margin-bottom: 10px;
}

.ds-section-header__title {
  font-family: var(--font-script);
  font-size: clamp(2.5rem, 5vw, 3.8rem);
  color: var(--text-dark);
  font-weight: 400;
  line-height: 1.1;
}

.ds-section-header__divider {
  display: flex;
  align-items: center;
  gap: 12px;
  justify-content: center;
  margin: 12px 0 0;
}
.ds-section-header__divider::before,
.ds-section-header__divider::after {
  content: '';
  width: 60px;
  height: 1px;
  background: linear-gradient(to right, transparent, var(--gold-light), transparent);
}
.ds-section-header__divider-icon {
  font-size: 0.85rem;
  color: var(--gold-light);
}

.ds-section-header__sub {
  color: var(--text-light);
  margin-top: 14px;
  font-size: 0.9rem;
  max-width: 520px;
  margin-left: auto;
  margin-right: auto;
  line-height: 1.75;
}

/* ── Modo claro (seções escuras) ── */
.ds-section-header--light .ds-section-header__title { color: var(--white); }
.ds-section-header--light .ds-section-header__tag   { color: var(--gold-light); }
.ds-section-header--light .ds-section-header__sub   { color: rgba(255,255,255,0.55); }
.ds-section-header--light .ds-section-header__divider::before,
.ds-section-header--light .ds-section-header__divider::after {
  background: linear-gradient(to right, transparent, rgba(232,184,75,0.6), transparent);
}
</style>
