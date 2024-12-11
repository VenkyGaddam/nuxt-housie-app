<template>
  <UPopover
    mode="hover"
    :popper="{ strategy: 'absolute' }"
    :ui="{ width: 'w-[156px]' }"
  >
    <template #default="{ open }">
      <UButton
        color="gray"
        variant="ghost"
        square
        :class="[open && 'bg-gray-50 dark:bg-gray-800']"
        aria-label="Color picker"
      >
        <UIcon
          name="i-heroicons-swatch-20-solid"
          class="w-5 h-5 text-primary-500 dark:text-primary-400"
        />
      </UButton>
    </template>

    <template #panel>
      <div class="p-2">
        <div class="grid grid-cols-5 gap-px">
          <ColorPickerPill
            v-for="color in primaryColors"
            :key="color.value"
            :color="color"
            :selected="primary"
            @select="primary = color"
          />
        </div>

        <hr class="border-gray-200 dark:border-gray-800 my-2" />

        <div class="grid grid-cols-5 gap-px">
          <ColorPickerPill
            v-for="color in grayColors"
            :key="color.value"
            :color="color"
            :selected="gray"
            @select="gray = color"
          />
        </div>
      </div>
    </template>
  </UPopover>
</template>
<script setup lang="ts">
import ColorPickerPill from "~/components/theme-picker/ColorPickerPill.vue";
import colors from "#tailwind-config/theme/colors";

const appConfig = useAppConfig();
const colorMode = useColorMode();

// Define the type for the color object to ensure type safety
interface ColorOption {
  value: string;
  text: string;
  hex: string;
}

// Assuming appConfig and colorMode are defined and reactive
const primaryColors = computed<ColorOption[]>(() =>
  appConfig.ui.colors
    .filter((color) => color !== "primary")
    .map((color) => {
      // Ensure `colors[color]` exists and access valid keys
      const colorHex = colors[color as keyof typeof colors] as Record<
        number,
        string
      >;
      return {
        value: color,
        text: color,
        hex: colorHex[colorMode.value === "dark" ? 400 : 500],
      };
    })
);

const primary = computed<ColorOption>({
  get() {
    return (
      primaryColors.value.find(
        (option) => option.value === appConfig.ui.primary
      ) || { value: "", text: "", hex: "" } // Default value to avoid undefined
    );
  },
  set(option) {
    if (option && option.value) {
      appConfig.ui.primary = option.value;
      // Update localStorage with the selected color
      const colorCookie = useCookie(`nuxt-ui-primary`);
      colorCookie.value = appConfig.ui.primary; // Sets the cookie
    }
  },
});

const grayColors = computed<ColorOption[]>(() =>
  ["slate", "cool", "zinc", "neutral", "stone"].map((color) => {
    // Assert that `colors[color]` exists and it's valid
    const colorHex = colors[color as keyof typeof colors] as Record<
      number,
      string
    >;
    return {
      value: color,
      text: color,
      hex: colorHex[colorMode.value === "dark" ? 400 : 500],
    };
  })
);

const gray = computed<ColorOption>({
  get() {
    return (
      grayColors.value.find((option) => option.value === appConfig.ui.gray) || {
        value: "",
        text: "",
        hex: "",
      } // Default value to avoid undefined
    );
  },
  set(option) {
    if (option && option.value) {
      appConfig.ui.gray = option.value;

      const colorCookie = useCookie(`nuxt-ui-gray`);
      colorCookie.value = appConfig.ui.gray; // Sets the cookie
    }
  },
});
</script>
