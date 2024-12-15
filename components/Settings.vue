<script setup lang="ts">
type SliderSide = "left" | "right" | "top" | "bottom";
// props
const props = defineProps({
  automaticMode: { type: Boolean, required: true },
  callOutDelay: { type: Number, required: true },
  callOutDelayOptions: { type: Array as PropType<number[]>, required: true },
  voiceMode: { type: Boolean, required: true },
  sliderSide: {
    type: String as PropType<SliderSide>,
    required: true,
  },
  onClose: {
    type: Function,
    required: true,
  },
});

// Reactive object to store settings
const settings = reactive({
  automaticMode: false,
  callOutDelay: 5, // Number call-out delay in automatic mode
  voiceMode: false,
});

const emits = defineEmits(["update"]);

const updateSettings = () => {
  emits("update", {
    automaticMode: settings.automaticMode,
    callOutDelay: settings.callOutDelay,
    voiceMode: settings.voiceMode,
  });
};

// onMounted lifecycle hook to assign props to settings
onMounted(() => {
  settings.automaticMode = props.automaticMode;
  settings.callOutDelay = props.callOutDelay;
  settings.voiceMode = props.voiceMode;
});

// Watch the entire settings object
watch(
  settings,
  () => {
    updateSettings();
  },
  { deep: true } // Necessary to track changes within a reactive object
);
</script>
<template>
  <USlideover
    :side="sliderSide"
    :ui="{
      height: 'h-screen max-h-dvh',
    }"
  >
    <UCard
      class="flex flex-col flex-1"
      :ui="{
        body: { base: 'flex-1' },
        ring: '',
        divide: 'divide-y divide-gray-100 dark:divide-gray-800',
      }"
    >
      <template #header>
        <div class="flex items-center justify-between">
          <div class="flex flex-row gap-5 items-center">
            <span class="text-xl font-bold">Settings</span>
          </div>
          <UButton
            color="gray"
            variant="ghost"
            icon="i-heroicons-x-mark-20-solid"
            class="-my-1"
            @click="onClose()"
          />
        </div>
      </template>

      <template #default>
        <div class="flex flex-col gap-5">
          <UFormGroup
            name="mode"
            label="Auto generate numbers"
            class="flex items-center justify-between py-2"
          >
            <UToggle v-model="settings.automaticMode" size="lg" />
          </UFormGroup>

          <transition
            name="fade-slide"
            enter-active-class="transition ease-out duration-300"
            enter-from-class="opacity-0 translate-y-4"
            enter-to-class="opacity-100 translate-y-0"
            leave-active-class="transition ease-in duration-300"
            leave-from-class="opacity-100 translate-y-0"
            leave-to-class="opacity-0 translate-y-4"
          >
            <UFormGroup
              v-show="settings.automaticMode"
              name="callOutDelay"
              label="Delay between numbers in seconds"
              class="flex items-center justify-between py-2"
            >
              <USelect
                v-model="settings.callOutDelay"
                :options="callOutDelayOptions"
              />
            </UFormGroup>
          </transition>
          <UFormGroup
            name="voiceMode"
            label="Enable voice feedback"
            class="flex items-center justify-between py-2"
          >
            <UToggle
              v-model="settings.voiceMode"
              size="lg"
              on-icon="i-heroicons-solid:speaker-wave"
              off-icon="i-heroicons-solid:speaker-x-mark"
            />
          </UFormGroup>

          <div>
            <NuxtLink
              to="/terms-and-conditions"
              class="text-blue-500 hover:underline"
              >Terms and Conditions</NuxtLink
            >
          </div>
        </div>
      </template>
    </UCard>
  </USlideover>
</template>
