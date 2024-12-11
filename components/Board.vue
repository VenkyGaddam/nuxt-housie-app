<script setup lang="ts">
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
});
</script>

<template>
  <UContainer class="max-h-dvh overflow-auto">
    <div
      class="grid grid-cols-10 rounded-md outline outline-2 outline-primary-500 overflow-clip mt-5"
    >
      <div
        v-for="number in numbers"
        :key="number"
        class="p-2 text-center"
        :class="{
          'bg-primary-500 text-white': selectedNumbers.includes(number),
        }"
      >
        {{ number }}
      </div>
    </div>
    <div class="text-xl font-bold my-5">History</div>
    <div class="flex flex-row gap-1 overflow-auto flex-wrap mb-32">
      <div
        v-for="num in selectedNumbers.slice().reverse()"
        :key="num"
        :class="{ 'bg-primary-500 text-white font-bold': num == currentNumber }"
        class="flex items-center justify-center w-8 h-8 border-2 border-primary-500 rounded-lg"
      >
        {{ num }}
      </div>
    </div>
  </UContainer>
</template>
