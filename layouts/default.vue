<script setup lang="ts">
import ColorPicker from "~/components/theme-picker/ColorPicker.vue";

const colorMode = useColorMode();
const appConfig = useAppConfig();

// Dark mode toggle
const isDark = computed({
  get() {
    return colorMode.preference == "dark";
  },
  set() {
    colorMode.preference = colorMode.preference === "dark" ? "light" : "dark";
  },
});
const isVisible = ref(false);

onMounted(() => {
  isVisible.value = true;
});
</script>

<template>
  <div class="min-h-dvh flex flex-col">
    <div
      class="sticky top-0 py-2 lg:py-2 px-2 lg:mr-2 backdrop-blur-md z-10 transform transition-all duration-[300ms] ease-in-out delay-[100ms] -translate-y-10 opacity-0"
      :class="{ 'translate-y-0 opacity-100': isVisible }"
    >
      <div class="flex flex-row gap-2 items-center justify-between">
        <ULink to="/">
          <div class="flex flex-row items-end gap-1">
            <UIcon
              :name="appConfig.brandIcon"
              class="w-12 h-12 text-primary-500"
            />
            <div class="flex flex-col">
              <span class="text-xl font-semibold text-primary-500">
                {{ appConfig.title }}
              </span>
              <span class="text-sm font-semibold"> Numbers generator </span>
            </div>
          </div>
        </ULink>

        <div class="flex flex-row gap-2.5 items-center">
          <ColorPicker />
          <UButton
            :icon="
              isDark
                ? 'i-line-md:sunny-filled-loop-to-moon-filled-loop-transition'
                : 'i-material-symbols:light-mode-rounded'
            "
            color="gray"
            size="md"
            variant="ghost"
            aria-label="Theme"
            @click="isDark = !isDark"
            :class="{
              'transition-transform  duration-500 ease-in-out': true,
              'rotate-90': !isDark,
              '-rotate-90': isDark,
              'opacity-100': !isDark,
              'opacity-70': isDark,
            }"
          />
        </div>
      </div>
    </div>

    <div class="flex-1">
      <slot />
    </div>
  </div>
</template>
