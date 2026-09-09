<template>
  <div class="login-page">
    <!-- Background decorativo -->
    <div class="login-bg">
      <div class="login-bg-circle c1"></div>
      <div class="login-bg-circle c2"></div>
    </div>

    <div class="login-card">
      <!-- Logo -->
      <div class="login-logo">
        <span class="login-logo-icon">💍</span>
        <div class="login-logo-name font-script">VouCasar</div>
        <div class="login-logo-sub">Painel dos Noivos</div>
      </div>

      <!-- Form -->
      <form class="login-form" @submit.prevent="handleLogin">
        <div class="form-group">
          <label for="loginEmail">E-mail</label>
          <input
            id="loginEmail"
            v-model="email"
            type="email"
            placeholder="seu@email.com"
            required
            autocomplete="email"
          />
        </div>
        <div class="form-group">
          <label for="loginPassword">Senha</label>
          <input
            id="loginPassword"
            v-model="password"
            type="password"
            placeholder="••••••••"
            required
            autocomplete="current-password"
          />
        </div>

        <div v-if="error" class="login-error">{{ error }}</div>

        <button type="submit" class="login-btn" :disabled="loading">
          <span v-if="loading">Entrando...</span>
          <span v-else>🔐 Entrar no Painel</span>
        </button>
      </form>

      <NuxtLink to="/" class="login-back">← Voltar ao site do casal</NuxtLink>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({
  layout: false,
  middleware: [],
})

useHead({
  title: 'Login — VouCasar Admin',
  meta: [{ name: 'robots', content: 'noindex' }],
})

const client = useSupabaseClient()
const router  = useRouter()
const user    = useSupabaseUser()

// Redirecionar se já autenticado
if (user.value) {
  await navigateTo('/admin/dashboard')
}

const email    = ref('')
const password = ref('')
const error    = ref('')
const loading  = ref(false)

async function handleLogin() {
  error.value   = ''
  loading.value = true
  try {
    const { error: err } = await client.auth.signInWithPassword({
      email: email.value,
      password: password.value,
    })
    if (err) {
      error.value = 'E-mail ou senha incorretos. Tente novamente.'
    } else {
      router.push('/admin/dashboard')
    }
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--bg-dark);
  padding: 24px;
  position: relative;
  overflow: hidden;
  font-family: var(--font-sans);
}
.login-bg { position: absolute; inset: 0; pointer-events: none; }
.login-bg-circle {
  position: absolute;
  border-radius: 50%;
  filter: blur(80px);
  opacity: 0.25;
}
.c1 {
  width: 500px; height: 500px;
  background: radial-gradient(circle, var(--rose-gold), transparent);
  top: -200px; left: -150px;
}
.c2 {
  width: 400px; height: 400px;
  background: radial-gradient(circle, var(--gold), transparent);
  bottom: -150px; right: -100px;
}

.login-card {
  position: relative;
  background: rgba(30, 20, 10, 0.85);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(201, 150, 125, 0.15);
  border-radius: var(--radius-xl);
  padding: 48px 40px;
  width: 100%;
  max-width: 420px;
  box-shadow: var(--shadow-strong);
}

.login-logo {
  text-align: center;
  margin-bottom: 36px;
}
.login-logo-icon {
  font-size: 2.5rem;
  display: block;
  margin-bottom: 8px;
  animation: pulse 2s infinite;
}
@keyframes pulse {
  0%,100% { transform: scale(1); }
  50%      { transform: scale(1.08); }
}
.login-logo-name {
  font-size: 2.2rem;
  color: var(--rose-gold-light);
  line-height: 1;
  margin-bottom: 6px;
}
.login-logo-sub {
  font-size: 0.75rem;
  letter-spacing: 0.2em;
  text-transform: uppercase;
  color: rgba(255,255,255,0.35);
}

.login-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
  margin-bottom: 24px;
}
.login-form .form-group label {
  color: rgba(255,255,255,0.5);
}
.login-form input {
  background: rgba(255,255,255,0.06);
  border-color: rgba(255,255,255,0.1);
  color: var(--white);
}
.login-form input:focus {
  border-color: var(--rose-gold);
  background: rgba(255,255,255,0.08);
}
.login-form input::placeholder { color: rgba(255,255,255,0.25); }

.login-error {
  background: rgba(239, 68, 68, 0.1);
  border: 1px solid rgba(239, 68, 68, 0.3);
  color: #fca5a5;
  padding: 10px 14px;
  border-radius: var(--radius-sm);
  font-size: 0.8rem;
  text-align: center;
}

.login-btn {
  padding: 14px;
  background: linear-gradient(135deg, var(--rose-gold-dark), var(--rose-gold));
  color: white;
  border-radius: var(--radius-full);
  font-size: 0.9rem;
  font-weight: 600;
  letter-spacing: 0.05em;
  transition: var(--transition);
  width: 100%;
}
.login-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(201, 150, 125, 0.4);
}
.login-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.login-back {
  display: block;
  text-align: center;
  font-size: 0.8rem;
  color: rgba(255,255,255,0.3);
  transition: var(--transition);
}
.login-back:hover { color: var(--rose-gold-light); }
</style>
