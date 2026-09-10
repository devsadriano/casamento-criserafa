<template>
  <!--
    DsIcon — Ícone decorativo do Design System
    Suporta: emoji | nome de ícone predefinido | círculo decorativo
  -->
  <span :class="classes" v-bind="$attrs" :style="style" :aria-label="label" :role="label ? 'img' : 'presentation'">
    <!-- Ícone por nome (SVG inline) -->
    <template v-if="name === 'sunflower'">
      <svg viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg" :width="sizePx" :height="sizePx">
        <!-- Pétalas -->
        <ellipse cx="16" cy="6"  rx="2.2" ry="4.5" fill="currentColor" transform="rotate(0   16 16)" opacity="0.9"/>
        <ellipse cx="16" cy="6"  rx="2.2" ry="4.5" fill="currentColor" transform="rotate(45  16 16)" opacity="0.85"/>
        <ellipse cx="16" cy="6"  rx="2.2" ry="4.5" fill="currentColor" transform="rotate(90  16 16)" opacity="0.9"/>
        <ellipse cx="16" cy="6"  rx="2.2" ry="4.5" fill="currentColor" transform="rotate(135 16 16)" opacity="0.85"/>
        <ellipse cx="16" cy="6"  rx="2.2" ry="4.5" fill="currentColor" transform="rotate(180 16 16)" opacity="0.9"/>
        <ellipse cx="16" cy="6"  rx="2.2" ry="4.5" fill="currentColor" transform="rotate(225 16 16)" opacity="0.85"/>
        <ellipse cx="16" cy="6"  rx="2.2" ry="4.5" fill="currentColor" transform="rotate(270 16 16)" opacity="0.9"/>
        <ellipse cx="16" cy="6"  rx="2.2" ry="4.5" fill="currentColor" transform="rotate(315 16 16)" opacity="0.85"/>
        <!-- Centro -->
        <circle cx="16" cy="16" r="5.5" fill="#7a5408"/>
        <circle cx="16" cy="16" r="4"   fill="#956a10"/>
        <!-- Pontos do centro -->
        <circle cx="14.5" cy="14.5" r="0.7" fill="rgba(0,0,0,0.25)"/>
        <circle cx="16"   cy="14"   r="0.7" fill="rgba(0,0,0,0.25)"/>
        <circle cx="17.5" cy="14.5" r="0.7" fill="rgba(0,0,0,0.25)"/>
        <circle cx="14"   cy="16"   r="0.7" fill="rgba(0,0,0,0.25)"/>
        <circle cx="16"   cy="16"   r="0.7" fill="rgba(0,0,0,0.25)"/>
        <circle cx="18"   cy="16"   r="0.7" fill="rgba(0,0,0,0.25)"/>
        <circle cx="14.5" cy="17.5" r="0.7" fill="rgba(0,0,0,0.25)"/>
        <circle cx="16"   cy="18"   r="0.7" fill="rgba(0,0,0,0.25)"/>
        <circle cx="17.5" cy="17.5" r="0.7" fill="rgba(0,0,0,0.25)"/>
      </svg>
    </template>

    <!-- Ícone por nome: anel/diamante -->
    <template v-else-if="name === 'ring'">
      <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" :width="sizePx" :height="sizePx">
        <circle cx="12" cy="14" r="7" stroke="currentColor" stroke-width="2" fill="none"/>
        <path d="M8 7 L10 3 L12 5 L14 3 L16 7" stroke="currentColor" stroke-width="1.5" fill="none" stroke-linejoin="round"/>
        <path d="M8 7 L16 7" stroke="currentColor" stroke-width="1.5"/>
      </svg>
    </template>

    <!-- Ícone por nome: coração -->
    <template v-else-if="name === 'heart'">
      <svg viewBox="0 0 24 24" fill="currentColor" xmlns="http://www.w3.org/2000/svg" :width="sizePx" :height="sizePx">
        <path d="M12 21.35L10.55 20.03C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
      </svg>
    </template>

    <!-- Emoji / texto genérico -->
    <template v-else>{{ emoji }}</template>
  </span>
</template>

<script setup lang="ts">
/**
 * DsIcon — Ícone decorativo padronizado
 *
 * Uso:
 *   <DsIcon name="sunflower" size="md" color="gold" />
 *   <DsIcon emoji="🌻" size="lg" circle />
 */
interface Props {
  name?:   'sunflower' | 'ring' | 'heart'
  emoji?:  string
  size?:   'xs' | 'sm' | 'md' | 'lg' | 'xl' | '2xl'
  color?:  'gold' | 'dark' | 'light' | 'white' | 'inherit'
  circle?: boolean   // Colocar em círculo decorativo
  label?:  string    // Acessibilidade
}

const props = withDefaults(defineProps<Props>(), {
  size:   'md',
  color:  'gold',
  circle: false,
})

const sizeMap = { xs: '14', sm: '18', md: '24', lg: '32', xl: '48', '2xl': '64' }
const sizePx = computed(() => sizeMap[props.size])

const classes = computed(() => [
  'ds-icon',
  `ds-icon--${props.size}`,
  `ds-icon--${props.color}`,
  { 'ds-icon--circle': props.circle },
])

const style = computed(() => ({
  fontSize: `${sizePx.value}px`,
}))
</script>

<style scoped>
.ds-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  line-height: 1;
  flex-shrink: 0;
}

/* Tamanhos */
.ds-icon--xs  { width: 14px; height: 14px; }
.ds-icon--sm  { width: 18px; height: 18px; }
.ds-icon--md  { width: 24px; height: 24px; }
.ds-icon--lg  { width: 32px; height: 32px; }
.ds-icon--xl  { width: 48px; height: 48px; }
.ds-icon--2xl { width: 64px; height: 64px; }

/* Cores */
.ds-icon--gold    { color: var(--gold); }
.ds-icon--dark    { color: var(--text-dark); }
.ds-icon--light   { color: var(--text-light); }
.ds-icon--white   { color: var(--white); }
.ds-icon--inherit { color: inherit; }

/* Círculo */
.ds-icon--circle {
  border-radius: 50%;
  background: linear-gradient(135deg, var(--sun-100), var(--sun-200));
  border: 1.5px solid var(--border-gold);
  padding: 10px;
  width: auto;
  height: auto;
}
.ds-icon--circle.ds-icon--sm  { padding: 6px; }
.ds-icon--circle.ds-icon--md  { padding: 10px; }
.ds-icon--circle.ds-icon--lg  { padding: 14px; }
.ds-icon--circle.ds-icon--xl  { padding: 18px; }
</style>
