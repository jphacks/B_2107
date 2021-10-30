<template>
  <div>
    <v-navigation-drawer app v-model="navBar" color="#00aa6e" height="37%">
      <v-divider />
      <v-list nav>
        <v-list-item v-for="menu in menus" :key="menu.title" :to="menu.url">
          <v-list-item-content>
            <v-list-item-title>{{ menu.title }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
    <v-app-bar app color="#00aa6e" class="header">
      <v-app-bar-nav-icon @click.stop="navBar = !navBar" x-large color="#fff" />

      <v-spacer><img src="@/assets/vivi.png"/></v-spacer>
    </v-app-bar>
  </div>
</template>

<script>
export default {
  name: "Header",
  data: () => ({
    navBar: false,
    selectURL: "",
    menus: [{ title: "ログアウト", url: "/" }],
  }),
};
</script>

<style>
.v-navigation-drawer {
  color: #fff;
  padding-top: 56px;
}

.v-list-item__title {
  color: #fff;
}

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
