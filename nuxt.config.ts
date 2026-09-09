// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2025-07-15',
  devtools: { enabled: false },
  modules: ['@nuxtjs/supabase'],

  ssr: true,

  supabase: {
    redirect: true,
    redirectOptions: {
      login: '/admin/login',
      callback: '/admin/confirm',
      exclude: [
        '/',
        '/admin/login',
        '/admin/confirm',
      ],
      saveRedirectToCookie: true
    },
    types: '~/types/database.types.ts',
  },

  css: ['~/assets/css/main.css'],

  runtimeConfig: {
    public: {
      weddingDate: '2025-04-12T17:00:00',
      groomName: 'Rafael',
      brideName: 'Cristina',
    }
  },

  build: {
    transpile: ['vue-toastification']
  }
})
