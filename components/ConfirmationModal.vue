<script lang="ts" setup>
defineProps({
  title: {
    type: String,
  },
  body: {
    type: String,
  },
  preventClose: {
    type: Boolean,
    default: false,
  },
  yes: {
    type: String,
  },
  no: {
    type: String,
  },
  onClickYes: {
    type: Function,
    required: true,
  },
  onClickNo: {
    type: Function,
    required: true,
  },
});
</script>

<template>
  <UModal :prevent-close="preventClose">
    <UCard>
      <template v-show="title" #header>
        <span class="text-xl font-bold">{{ title }}</span>
      </template>

      <div>
        {{ body || "Are you sure to proceed?" }}
      </div>

      <template #footer>
        <div class="flex flex-row justify-between">
          <UButton
            color="amber"
            variant="outline"
            size="lg"
            @click="onClickNo()"
            >{{ no || "Cancel" }}</UButton
          >
          <UButton
            color="red"
            variant="outline"
            size="lg"
            @click="onClickYes()"
            >{{ yes || "Accept" }}</UButton
          >
        </div>
      </template>
    </UCard>
  </UModal>
</template>
