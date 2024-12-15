<script setup lang="ts">
type SliderSide = "left" | "right" | "top" | "bottom";

// props
const props = defineProps({
  numbers: {
    type: Array as PropType<number[]>,
    required: true,
  },
  selectedNumbers: {
    type: Array as PropType<number[]>,
    required: true,
  },
  currentNumber: {
    type: Number,
    required: true,
  },
  sliderSide: {
    type: String as PropType<SliderSide>,
    required: true,
  },
  onClose: {
    type: Function,
    required: true,
  },
});
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
        body: { base: 'flex-1', padding: 'px-2 py-0 sm:p-0' },
        ring: '',
        divide: 'divide-y divide-gray-100 dark:divide-gray-800',
      }"
    >
      <template #header>
        <div class="flex items-center justify-between">
          <div>
            <span class="text-xl font-bold">Board</span>
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
        <Board
          :numbers="numbers"
          :selectedNumbers="selectedNumbers"
          :currentNumber="currentNumber"
        />
      </template>
    </UCard>
  </USlideover>
</template>
