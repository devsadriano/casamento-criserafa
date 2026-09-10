<template>
  <!-- Layout padrão com girassol de fundo -->
  <div class="default-layout">
    <!-- Girassol background layer -->
    <div class="sunflower-bg-layer" aria-hidden="true"></div>
    <slot />
  </div>
</template>

<style>
.default-layout {
  position: relative;
  min-height: 100vh;
}

/* Camada de fundo com o girassol */
.sunflower-bg-layer {
  position: fixed;
  inset: 0;
  background-color: var(--bg-primary);
  background-image: url('/sunflower_bg.png');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  opacity: 0.32;
  pointer-events: none;
  z-index: 0;
}

/* Garante que o conteúdo fique acima do background */
.default-layout > *:not(.sunflower-bg-layer) {
  position: relative;
  z-index: 1;
}
</style>
