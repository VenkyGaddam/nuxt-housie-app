<script setup lang="ts">
import BoardSlideover from "~/components/BoardSlideover.vue";
import Settings from "~/components/Settings.vue";
import ConfirmationModal from "~/components/ConfirmationModal.vue";
import voicesAll from "~/public/en.json";

const appConfig = useAppConfig();

definePageMeta({
  middleware: "default",
});

const numbers = Array.from({ length: 90 }, (_, i) => i + 1);
const selectedNumbers = ref<number[]>([]);
const currentNumber = ref();
const buttonText = ref("Start");
selectedNumbers.value = [];

const colorClasses = [
  "bg-primary-50",
  "bg-primary-100",
  "bg-primary-200",
  "bg-primary-300",
  "bg-primary-400",
];

// Settings state
const automaticMode = ref(false);
const callOutDelayOptions: number[] = [3, 5, 10, 15, 30, 60];
const callOutDelay = ref<number>(callOutDelayOptions[0]);
const voiceMode = ref(false);
const debounce = ref(false);

// components
const slideover = useSlideover();
const modal = useModal();

// A reactive property for font size
const computedFontSize = ref(0);
const openSliderOnRight = ref(false);

type SliderSide = "left" | "right" | "top" | "bottom";

const sliderSide = computed<SliderSide>(() => {
  return openSliderOnRight.value ? "right" : "bottom";
});

// Variable to store interval ID for automatic mode
let autoGenerateInterval: ReturnType<typeof setInterval> | null = null;

const GameState = {
  NOT_STARTED: "not_started",
  IN_PROGRESS: "in_progress",
  PAUSED: "paused",
  GAME_OVER: "game_over",
};

console.log("Enjoy playing!");

// Speech synthesis variables
let voicesAvailable: Array<
  (typeof voicesAll.voices)[0] & { nativeVoice: SpeechSynthesisVoice }
> = [];
let voicesDevice: SpeechSynthesisVoice[] = [];
let voicesRetryCount = 0;
const isSpeechSynthesisAvailable = ref(false);

// Function to generate a random number and add it to selected numbers
const generateRandomNumber = () => {
  const availableNumbers = numbers.filter(
    (n) => !selectedNumbers.value.includes(n)
  );
  if (availableNumbers.length > 0) {
    const randomNumber =
      availableNumbers[Math.floor(Math.random() * availableNumbers.length)];
    currentNumber.value = randomNumber;
    selectedNumbers.value.push(randomNumber);

    // save numbers to local storage. In case accidental browser closure we resurrect the data.
    saveSelectedNumbers();

    // Call out the number
    if (voiceMode.value) speakNumber(randomNumber);
  } else {
    // Updatet text to Game over
    buttonText.value = "Game over";
  }
};

const gameState = computed(() => {
  if (selectedNumbers.value.length === 0) {
    buttonText.value = "Start";
    return GameState.NOT_STARTED;
  }

  if (selectedNumbers.value.length === numbers.length) {
    buttonText.value = "Game over";
    return GameState.GAME_OVER;
  }

  if (automaticMode.value) {
    return autoGenerateInterval ? GameState.IN_PROGRESS : GameState.PAUSED;
  }

  return GameState.IN_PROGRESS;
});

// Open the slideover to show the board on mobiles
const openBoard = () => {
  // Pause game
  pauseGame();

  slideover.open(BoardSlideover, {
    numbers: numbers,
    selectedNumbers: selectedNumbers.value,
    currentNumber: currentNumber.value,
    sliderSide: sliderSide.value,
    onClose: slideover.close,
  });
};

// Open the settings slideover
const openSettings = () => {
  // Pause game
  pauseGame();

  slideover.open(Settings, {
    automaticMode: automaticMode.value,
    callOutDelay: Number(callOutDelay.value),
    callOutDelayOptions,
    voiceMode: voiceMode.value,
    sliderSide: sliderSide.value,
    onClose: slideover.close,
    onUpdate: (newSettings: {
      automaticMode: boolean;
      callOutDelay: number;
      voiceMode: boolean;
    }) => {
      automaticMode.value = newSettings.automaticMode;
      callOutDelay.value = newSettings.callOutDelay;
      voiceMode.value = newSettings.voiceMode;
      saveSettings();
      handleSettingsChange();
    },
  });
};

const handleSettingsChange = () => {
  if (gameState.value == GameState.NOT_STARTED) {
    buttonText.value = "Start";
    return;
  }
  if (automaticMode.value) {
    buttonText.value = "Resume";
  } else {
    // Disable automatic mode if it was enabled
    if (autoGenerateInterval) {
      clearInterval(autoGenerateInterval);
      autoGenerateInterval = null;
    }
    // Change text to Next
    buttonText.value = "Next";
  }
};

// Function to handle "Start", "Pause", "Resume", and "Next"
const handleGame = () => {
  if (automaticMode.value) {
    // In automatic mode, toggle between pause and resume
    if (autoGenerateInterval) {
      // Pause the game
      clearInterval(autoGenerateInterval);
      autoGenerateInterval = null;
      buttonText.value = "Resume";
    } else {
      // Resume the game
      // Fire number immediately
      generateRandomNumber();
      // Then generate numbers with delay
      autoGenerateInterval = setInterval(
        generateRandomNumber,
        callOutDelay.value * 1000
      );
      buttonText.value = "Pause";
    }
  } else {
    // In manual mode, start the game
    buttonText.value = "Next";
    debounce.value = true; //Set state to debounce to not let use click the button immediately
    generateRandomNumber();
    setTimeout(() => {
      debounce.value = false;
    }, 1000);
  }
};

// Pause game
const pauseGame = () => {
  if (automaticMode.value) {
    if (autoGenerateInterval) {
      // Pause the game
      clearInterval(autoGenerateInterval);
      autoGenerateInterval = null;
      buttonText.value = "Resume";
    }
  }
};

// Function to reset the current game with confirmation
const resetGame = () => {
  // puase the game
  pauseGame();
  modal.open(ConfirmationModal, {
    title: "Confirm Reset",
    body: "Are you sure, you want to reset the game?",
    yes: "Reset Game",
    no: "Cancel",
    onClickNo: () => {
      modal.close();
    },
    onClickYes: () => {
      // Proceed with the game reset
      selectedNumbers.value.length = 0;
      currentNumber.value = null;
      buttonText.value = "Start";

      // Clear interval if any
      if (autoGenerateInterval) {
        clearInterval(autoGenerateInterval);
        autoGenerateInterval = null;
      }
      modal.close();
    },
  });
};

// Load settings from localStorage
const loadSettings = () => {
  const savedSettings = JSON.parse(
    localStorage.getItem("housieSettings") || "{}"
  );

  automaticMode.value = savedSettings.automaticMode ?? false;
  callOutDelay.value = savedSettings.callOutDelay || callOutDelayOptions[0];
  voiceMode.value = savedSettings.voiceMode ?? false;
};

// Save settings to localStorage
const saveSettings = () => {
  const settings = {
    automaticMode: automaticMode.value,
    callOutDelay: callOutDelay.value,
    voiceMode: voiceMode.value,
  };
  localStorage.setItem("housieSettings", JSON.stringify(settings));
};

// Store selectedNumbers in localStorage
const saveSelectedNumbers = () => {
  localStorage.setItem(
    "selectedNumbers",
    JSON.stringify(selectedNumbers.value)
  );
};

// Load selectedNumbers from localStorage
const loadSelectedNumbers = () => {
  const savedNumbers = JSON.parse(
    localStorage.getItem("selectedNumbers") || "[]"
  );
  if (savedNumbers.length == numbers.length || savedNumbers.length == 0) {
    // If no saved data or game over, proceed with the default empty list to start Game
    selectedNumbers.value = [];
    buttonText.value = "Start";
  } else {
    // If there are saved numbers, alert the user to continue the game or not

    modal.open(ConfirmationModal, {
      title: "Game Found!",
      body: "You have an incomplete game from last session. Do you want to continue?",
      preventClose: true,
      yes: "Continue",
      no: "New Game",
      onClickNo: () => {
        selectedNumbers.value = [];
        buttonText.value = "Start";
        localStorage.removeItem("selectedNumbers");
        modal.close();
      },
      onClickYes: () => {
        selectedNumbers.value = savedNumbers;
        if (automaticMode.value) {
          buttonText.value = "Resume";
        } else {
          buttonText.value = "Next";
        }
        currentNumber.value =
          selectedNumbers.value[selectedNumbers.value.length - 1];
        modal.close();
      },
    });
  }
};

const prepareSpeech = () => {
  if (!("speechSynthesis" in window)) {
    console.log("Speech synthesis not supported in this browser.");
    isSpeechSynthesisAvailable.value = false;
    return;
  }

  // if voice are not already loaded
  if (voicesDevice.length == 0) {
    voicesDevice = window.speechSynthesis.getVoices();
    voicesDevice = voicesDevice.filter((v) => v.name != "");

    // in the first go if no voices are found wait for change
    if (voicesDevice.length == 0) {
      window.speechSynthesis.onvoiceschanged = () => {
        voicesDevice = window.speechSynthesis.getVoices();
        voicesDevice = voicesDevice.filter((v) => v.name != "");

        if (voicesDevice.length > 0) {
          prepareSpeech();
        }
      };
    }
  }

  if (voicesDevice.length == 0) return;

  voicesAll.voices.forEach((voice) => {
    const foundVoice = voicesDevice.find((v) => v.name === voice.name);
    if (foundVoice) {
      voicesAvailable.push({ ...voice, nativeVoice: foundVoice });
    } else if (voice.altNames) {
      voice.altNames.forEach((altName) => {
        const altVoice = voicesDevice.find((v) => v.name === altName);
        if (altVoice) {
          voicesAvailable.push({
            ...voice,
            name: altName,
            nativeVoice: altVoice,
          });
        }
      });
    }
  });

  // Filter voices to prefer females
  const femaleVoices = voicesAvailable.filter(
    (voice) => voice.gender === "female"
  );
  const maleVoices = voicesAvailable.filter((voice) => voice.gender === "male");

  // Combine female voices first and then male voices
  voicesAvailable = [];
  voicesAvailable = [...femaleVoices, ...maleVoices];

  if (voicesAvailable.length != 0) isSpeechSynthesisAvailable.value = true;
};

// Function to speak a number
const speakNumber = (number: number) => {
  if (!isSpeechSynthesisAvailable) {
    alert("Speech synthesis is not supported in your browser.");
    return;
  }

  const voice: SpeechSynthesisVoice | null = (() => {
    if (voicesAvailable.length > 0) {
      return voicesAvailable[0].nativeVoice;
    }
    return null;
  })();

  const utterance = new SpeechSynthesisUtterance();
  utterance.lang = "en-US"; // Adjust language if needed
  utterance.rate = 1; // Adjust speed if needed
  if (voice) utterance.voice = voice;

  // Speak each digit of the number
  const digits = String(number).split("");
  const speakDigits = () => {
    digits.forEach((digit, index) => {
      setTimeout(() => {
        const digitUtterance = new SpeechSynthesisUtterance(digit);
        digitUtterance.lang = "en-US";
        if (voice) digitUtterance.voice = voice;
        window.speechSynthesis.speak(digitUtterance);
      }, index * 250); // 1-second delay between digits
    });
  };

  // Speak the full number after digits
  const speakFullNumber = () => {
    setTimeout(() => {
      utterance.text = `Number ${number}`;
      window.speechSynthesis.speak(utterance);
    }, digits.length * 500); // Delay after the digits are spoken
  };

  speakDigits();
  speakFullNumber();
};

// Calculate font size dynamically based on viewport dimensions
const updateElementSizes = () => {
  const size = Math.floor(
    Math.max(window.innerWidth, window.innerHeight) / 2.5
  ); // You can adjust the divisor as per your needs
  size >= 200
    ? (computedFontSize.value = 200)
    : (computedFontSize.value = size);

  // on wide screens open sliders on right
  window.innerWidth >= 640
    ? (openSliderOnRight.value = true)
    : (openSliderOnRight.value = false);
};

const isVisible = ref(false);
// Lifecycle hook
onMounted(() => {
  loadSettings();
  loadSelectedNumbers();

  // Initial font size calculation
  updateElementSizes();
  isVisible.value = true;
  // intilise speech
  prepareSpeech();

  // Update font size on window resize
  window.addEventListener("resize", updateElementSizes);
});

// Clean up interval & event listener on unmount
onBeforeUnmount(() => {
  if (autoGenerateInterval) {
    clearInterval(autoGenerateInterval);
  }

  window.removeEventListener("resize", updateElementSizes);
});
</script>

<template>
  <UContainer
    class="flex flex-col h-full gap-5 overflow-auto select-none transform transition-all duration-[300ms] ease-in-out delay-[250ms] translate-y-10 opacity-0"
    :class="{ 'translate-y-0 opacity-100': isVisible }"
  >
    <div
      class="flex-1 min-h-[50vh] flex flex-col justify-center items-center overflow-auto"
    >
      <div v-show="gameState !== GameState.NOT_STARTED">
        <span
          class="font-bold text-center subpixel-antialiased tracking-tighter text-primary-500"
          :style="{
            fontSize: `${computedFontSize}px`,
          }"
        >
          {{ currentNumber }}
        </span>
      </div>
      <div v-show="gameState == GameState.NOT_STARTED" class="mt-auto">
        <UIcon
          :name="appConfig.brandIcon"
          class="animate-bounce w-36 h-36 text-primary-500"
        />
      </div>

      <div class="flex flex-row gap-2.5 mt-auto">
        <div
          v-for="(num, index) in selectedNumbers.slice(-5)"
          :key="num"
          :class="colorClasses[index]"
          class="flex items-center justify-center w-10 h-10 text-md rounded-lg"
        >
          <span class="text-primary-900 text-semibold">{{ num }}</span>
        </div>
      </div>
    </div>

    <div class="flex flex-col items-center justify-center gap-5 mb-auto">
      <UButton
        class="px-16 lg:px-24"
        :disabled="gameState == GameState.GAME_OVER || debounce"
        size="xl"
        variant="solid"
        @click="handleGame"
        aria-label="Start or continue the game"
      >
        <span class="text-2xl font-bold">
          {{ buttonText }}
        </span>
        <template #trailing>
          <div v-show="automaticMode" class="relative inline-block w-8 h-8">
            <UIcon name="i-solar:repeat-bold" class="w-full h-full" />
            <span
              class="absolute inset-0 flex items-center justify-center text-xs"
            >
              {{ callOutDelay }} <span class="text-[0.5rem]">s</span>
            </span>
          </div>
        </template>
      </UButton>
      <UButtonGroup size="xl" orientation="horizontal">
        <UButton
          :disabled="gameState == GameState.NOT_STARTED"
          label="Show Board"
          variant="outline"
          @click="openBoard"
          aria-label="Show board"
        />

        <UButton
          :disabled="!isSpeechSynthesisAvailable"
          :icon="
            voiceMode
              ? 'i-heroicons-solid:speaker-wave'
              : 'i-heroicons-solid:speaker-x-mark'
          "
          variant="outline"
          @click="
            () => {
              voiceMode = !voiceMode;
              saveSettings();
            }
          "
          aria-label="enable or disable voice feedback for numbers"
        />
        <UButton
          icon="i-material-symbols:settings-suggest-outline"
          variant="outline"
          @click="openSettings"
          aria-label="Open settings"
        />
      </UButtonGroup>
      <UButton
        class="px-16 lg:px-24"
        :disabled="gameState == GameState.NOT_STARTED"
        label="Reset Game"
        variant="ghost"
        color="red"
        size="xl"
        @click="resetGame"
        aria-label="reset game"
      />
    </div>
  </UContainer>
</template>
