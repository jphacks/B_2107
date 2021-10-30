<template>
  <div>
    <v-app-bar app color="#00aa6e" class="header">
      <v-app-bar-nav-icon x-large color="#fff" />

      <v-spacer><img src="@/assets/vivi.png"/></v-spacer>
      <v-btn icon>
        <v-icon large color="#fff">mdi-dots-vertical</v-icon>
      </v-btn>
    </v-app-bar>
  </div>
</template>

<script>
export default {
  name: "Header",
};
</script>

<style>
.header {
  max-width: 100%;
  max-height: 100%;
  padding: 0 2%;
}

img {
  width: 240px;
}

button {
  margin-bottom: 10px;
}
</style>
