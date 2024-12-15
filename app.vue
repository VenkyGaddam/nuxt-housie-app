<script setup lang="ts">
const appConfig = useAppConfig();
const colorMode = useColorMode();
import colors from "#tailwind-config/theme/colors";

const color = computed(() =>
  colorMode.value === "dark" ? (colors as any)[appConfig.ui.gray][900] : "white"
);

console.log(color.value);

useHead({
  title: appConfig.title,
  meta: [
    { charset: "utf-8" },
    {
      name: "viewport",
      content: "width=device-width, initial-scale=1",
    },
    {
      name: "google-site-verification",
      content: "_YMH-3o88I9HanvBOqpF_4ueRFGtYK5qrViWowSOid8",
    },
  ],
  bodyAttrs: {
    class: "no-scrollbar bg-gray-100 dark:bg-gray-900",
  },
  htmlAttrs: {
    lang: "en",
  },
  script: [
    {
      src: "https://cloud.umami.is/script.js",
      defer: true,
      "data-website-id": "4052c5f7-ab12-4381-a0ec-717ef86b6137",
    },
  ],
});

useSeoMeta({
  title: "Housie|Tambola Number Picker",
  description:
    "Generate random Housie or Tambola numbers with ease. A fun and interactive tool for your next game night!",
  keywords:
    "Housie, Tambola, Number Generator, Game Night, Random Picker, Bingo Numbers",
  ogTitle: "Housie Number Generator",
  ogDescription:
    "The best tool to generate Tambola or Housie numbers instantly!",
  ogImage: "/web-app-manifest-512x512.png", // Replace with your actual image path
  ogUrl: "https://housie.myhive.in", // Replace with your website URL
  twitterCard: "summary_large_image",
  twitterSite: "@venkygaddam", // Replace with your Twitter handle
  twitterCreator: "@venkygaddam", // Replace with your Twitter handle
});
</script>

<template>
  <NuxtLoadingIndicator />
  <NuxtLayout>
    <NuxtPage />
  </NuxtLayout>
  <USlideovers />
  <UModals />
</template>

<style>
/* Fade and Scale Animation */

/* Entering page */
.fade-scale-enter-active {
  transition: opacity 0.5s ease, transform 0.5s ease;
}
.fade-scale-enter-from {
  opacity: 0;
  transform: scale(0.95);
}
.fade-scale-enter-to {
  opacity: 1;
  transform: scale(1);
}

/* Leaving page */
.fade-scale-leave-active {
  transition: opacity 0.5s ease, transform 0.5s ease;
}
.fade-scale-leave-from {
  opacity: 1;
  transform: scale(1);
}
.fade-scale-leave-to {
  opacity: 0;
  transform: scale(0.95);
}
/* Hide scrollbar for Chrome, Safari and Opera */
.no-scrollbar::-webkit-scrollbar {
  display: none;
}
/* Hide scrollbar for IE, Edge and Firefox */
.no-scrollbar {
  -ms-overflow-style: none; /* IE and Edge */
  scrollbar-width: 0; /* Firefox */
}
</style>
