<template>
  <v-app id="inspire">
    <v-app-bar
      app
      shrink-on-scroll
    >

      <v-toolbar-title>一覧</v-toolbar-title>

      <v-spacer></v-spacer>

      <v-btn icon>
        <v-icon>mdi-dots-vertical</v-icon>
      </v-btn>
    </v-app-bar>

    <v-main>
      <v-container>
        <v-row>
          <v-col
            v-for="n in 24"
            :key="n"
            cols="4"
          >
            <!-- <v-card height="200"></v-card> -->
            <router-link :to="{ path: '/chat', query: { user_id: n }}"> <v-avatar
  color="primary"
  size="56"
></v-avatar></router-link>
     
           
          </v-col>
        </v-row>
      </v-container>
    </v-main>
  </v-app>
</template>

<script>
  export default {
    //
  }
</script>