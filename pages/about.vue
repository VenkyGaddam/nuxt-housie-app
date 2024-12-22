<template>
  <UContainer>
    <h1 class="text-3xl font-bold text-center mb-8">About</h1>

    <!-- Profile Section -->
    <section class="mb-16">
      <h2 class="text-2xl font-semibold mb-4">About Me</h2>
      <div class="flex flex-col md:flex-row items-center md:items-start gap-8">
        <img
          src="https://avatars.githubusercontent.com/u/13492510?v=4&size=400"
          alt="Profile Picture"
          class="w-40 h-40 rounded-full border-1 border-primary-500"
        />
        <div>
          <p class="text-lg mb-4">
            Hello! I'm <strong>Venky Gaddam</strong>, a passionate developer
            with a strong focus on creating engaging and interactive web
            applications. With a little background in web apps development.
          </p>
          <p class="text-lg mb-4">
            This Housie Number Generator app is a fun project to bring the
            excitement of the classic Housie game to your fingertips. I enjoy
            working on projects that challenge me to learn and grow as a
            developer.
          </p>
          <p class="text-lg">
            Feel free to check out my work on
            <a
              href="https://github.com/VenkyGaddam/nuxt-housie-app"
              target="_blank"
              class="text-blue-500 hover:underline"
              >GitHub</a
            >.
          </p>
        </div>
      </div>
    </section>

    <!-- Game Description Section -->
    <section class="mb-16">
      <h2 class="text-2xl font-semibold mb-4">About the Game</h2>
      <p class="text-lg mb-4">
        The Housie Number Generator app brings the traditional Housie (or
        Tambola) game to a modern, digital format. This app allows players to
        generate random numbers, view the last 5 numbers, and access essential
        controls like starting, pausing, and resetting the game.
      </p>
      <ul class="list-disc list-inside text-lg mb-4">
        <li>Generate random Housie numbers in real-time.</li>
        <li>View the last 5 generated numbers.</li>
        <li>Start, pause, resume, and reset the game with ease.</li>
        <li>Enable or disable sound effects for a personalized experience.</li>
      </ul>
      <p class="text-lg">
        Whether you're hosting a family game night or a large event, this app
        makes it easy to manage the Housie game experience in a simple and
        intuitive way.
      </p>
    </section>

    <!-- Contact Section -->
    <section class="mb-16">
      <h2 class="text-2xl font-semibold mb-4">Contact</h2>
      <p class="text-lg mb-4">
        I’d love to hear from you! Whether you have questions, feedback, or just
        want to connect, feel free to reach out.
      </p>
      <p class="text-lg">
        You can contact me via email at
        <a
          href="mailto:ndrdmarshmallow@gmail.com"
          class="text-blue-500 hover:underline"
          >ndrdmarshmallow@gmail.com</a
        >.
      </p>
    </section>
  </UContainer>
</template>
