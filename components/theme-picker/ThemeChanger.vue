<script setup lang="ts">
const colorMode = useColorMode();

// Dark mode toggle
const isDark = computed({
  get() {
    return colorMode.preference == "dark";
  },
  set() {
    colorMode.preference = colorMode.preference === "dark" ? "light" : "dark";
  },
});
</script>

<template>
  <UButton
    color="gray"
    variant="ghost"
    square
    aria-label="Theme change"
    @click="isDark = !isDark"
    class="relative flex justify-center items-center w-8 h-8 overflow-hidden"
  >
    <!-- Current Icon (Sliding Down) -->
    <span
      :class="{
        'absolute transition-transform duration-700 ease-in-out transform': true,
        'translate-y-0.5 opacity-100': isDark,
        'translate-y-full opacity-0': !isDark,
      }"
    >
      <UIcon
        name="i-line-md:sunny-filled-loop-to-moon-filled-loop-transition"
        class="h-5 w-5"
      />
    </span>

    <!-- Next Icon (Sliding In from Top) -->
    <span
      :class="{
        'absolute transition-transform duration-700 ease-in-out transform': true,
        '-translate-y-full opacity-0': isDark,
        'translate-y-0.5 opacity-100': !isDark,
      }"
    >
      <UIcon name="i-material-symbols:light-mode-rounded" class="h-5 w-5" />
    </span>
  </UButton>
</template>
