// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2025-07-15',
  devtools: { enabled: false },
  modules: ['@nuxtjs/supabase'],

  ssr: true,

  app: {
    head: {
      htmlAttrs: {
        lang: 'pt-BR'
      },
      link: [
        { rel: 'preconnect', href: 'https://fonts.googleapis.com' },
        { rel: 'preconnect', href: 'https://fonts.gstatic.com', crossorigin: '' },
        {
          rel: 'stylesheet',
          href: 'https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,500;0,600;1,300;1,400&family=Great+Vibes&family=Inter:wght@300;400;500;600&family=Playfair+Display:ital,wght@0,400;0,600;1,400&display=swap'
        }
      ]
    }
  },

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
