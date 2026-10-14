// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2025-07-15',
  devtools: { enabled: true },
  runtimeConfig: {
    public: {
      BASE_URL: process.env.BASE_URL,
      URL_FILES: process.env.URL_FILES,
      // The customer-facing API (hawwel-api) - distinct from BASE_URL,
      // which is this dashboard's own admin API. Chat lives on the
      // customer-facing one since that's the only backend the mobile app
      // talks to directly.
      CHAT_API_URL: process.env.CHAT_API_URL,
    }
  },
  colorMode: {
    preference: 'light'
  },
  modules: ['@nuxt/ui', '@pinia/nuxt', 'pinia-plugin-persistedstate/nuxt', '@nuxtjs/i18n', 'nuxt-icon'],
  css: ["~/../app/assets/css/main.css"],
  app: {
    head: {
      link: [
        {
          rel: 'icon',
          type: 'image/png',
          href: '/logo.png'
        },
        {
          rel: 'preconnect',
          href: 'https://fonts.googleapis.com'
        },
        {
          rel: 'preconnect',
          href: 'https://fonts.gstatic.com',
          crossorigin: ''
        },
        {
          rel: 'stylesheet',
          href: 'https://fonts.googleapis.com/css2?family=Cairo:wght@200..1000&display=swap'
        }
      ]
    }
  },
  plugins: [
    // { src: '~/../app/plugins/vue-country-intl.client.js', mode: 'client' }
  ],
  i18n: {
    strategy: 'no_prefix',
    defaultLocale: 'en',
    locales: [
      { code: 'en', name: 'English', file: 'en.json' },
      { code: 'ar', name: 'Arabic', file: 'ar.json' }
    ]
  },
  icon: {
    provider: 'local', // ⚠️ مهم: استخدم local
    local: {
      collections: [
        'heroicons',
        'lucide',      // ← أضف هذا
        'mdi',         // ← وهذا
        'fa6-regular', // ← وهذا
        'fa6-solid'    // ← وهذا
      ]
    }
  }
})