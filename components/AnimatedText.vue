<script setup>
const props = defineProps({
  text: {
    type: String,
    required: true,
  },
  class: {
    type: String,
    required: true,
  },
});

const displayedText = ref("");
const showCaret = ref(true);

const typingDelay = 125; // Time between each character in milliseconds
const restartDelay = 3000; // Delay before restarting the animation

const typeText = async () => {
  while (true) {
    // Typing the text
    for (let i = 0; i < props.text.length; i++) {
      displayedText.value += props.text[i];
      await new Promise((resolve) => setTimeout(resolve, typingDelay));
    }

    // Delay before erasing
    await new Promise((resolve) => setTimeout(resolve, restartDelay));

    // Erasing the text
    for (let i = props.text.length; i >= 0; i--) {
      displayedText.value = props.text.slice(0, i);
      await new Promise((resolve) => setTimeout(resolve, typingDelay));
    }

    // Delay before restarting
    await new Promise((resolve) => setTimeout(resolve, restartDelay));
  }
};

onMounted(() => {
  // Start typing effect
  typeText();

  // Toggle caret visibility for blinking effect
  setInterval(() => {
    showCaret.value = !showCaret.value;
  }, 500); // Blink Caret
});
</script>

<template>
  <div class="text-center">
    <span class="tracking-tighter text-primary-500">
      <span :class="class">
        {{ displayedText }}
      </span>
      <span
        class="text-primary-500 caret-blink"
        :class="{ 'opacity-0': !showCaret }"
      >
        |
      </span>
    </span>
  </div>
</template>

<style scoped>
/* Tailwind CSS caret animation */
.caret-blink {
  transition: opacity 0.5s ease-in-out;
}
</style>
