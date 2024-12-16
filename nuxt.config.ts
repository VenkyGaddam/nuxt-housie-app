// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  generate: {
    routes: ["/terms-and-conditions", "/about"],
  },
  compatibilityDate: "2024-11-01",
  devtools: { enabled: true },
  modules: ["@nuxt/ui"],
  colorMode: {
    preference: "system", // default value of $colorMode.preference
    fallback: "dark", // fallback value if not system preference found
    storage: "localStorage", // or 'sessionStorage' or 'cookie'
    storageKey: "nuxt-color-mode",
  },
});
