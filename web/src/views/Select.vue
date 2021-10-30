<template>
  <div class="my-2">
    <Header />
    <div class="select">
      <div class="item">
        <img class="image_1" src="@/assets/img/img_1.png" />
        <v-btn x-large outlined color="#00AA6E" @click="sky">
          会議を立ち上げる
        </v-btn>
      </div>
      <div class="item">
        <img class="image_2" src="@/assets/img/img_2.png" />
        <v-btn x-large outlined color="#00AA6E" @click="meet">
          既存の会議を使用する
        </v-btn>
      </div>
    </div>
  </div>
</template>
<script>
import Header from "../components/layout/Header.vue";
export default {
  components: {
    Header,
  },
  methods: {
    sky() {
      this.$router
        .push({
          name: "Video",
          params: {
            id: this.$route.params.id,
            password: this.$route.params.password,
          },
        })
        .catch(() => {});
    },
    meet() {
      this.$router
        .push({
          name: "Meet",
          params: {
            id: this.$route.params.id,
            password: this.$route.params.password,
          },
        })
        .catch(() => {});
    },
  },
};
</script>

<style>
.my-2 {
  max-height: 100%;
  max-width: 100%;
}

.select {
  display: flex;
  justify-content: center;
  gap: 10%;
  align-items: center;
  align-items: flex-end;
}

.item {
  display: flex;
  flex-direction: column;
  align-items: flex-center;
  padding-top: 280px;
}

.image_2 {
  margin-left: 70px;
  width: 40%;
  height: auto;
}

.item .v-btn {
  margin-top: 30px;
  border-width: 1px;
}
</style>
