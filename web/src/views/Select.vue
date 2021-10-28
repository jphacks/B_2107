<template>
    <div class="my-2">
            <v-btn
              x-large
              color="#008000"
              dark
              @click="sky"
            >
              Skyで会議を立ち上げる
            </v-btn>
             <v-btn
              x-large
              color="#4169e1"
              dark
              @click="meet"
            >
              既存の会議を使用する
            </v-btn>
          </div>
          
</template>
<script>
export default {
  methods:{
    sky(){
       this.$router.push({name:"Video", params: {id: this.$route.params.id, password: this.$route.params.password}}).catch(() => {});
    },
    meet(){
      this.$router.push({name:"Meet", params: {id: this.$route.params.id, password: this.$route.params.password}}).catch(() => {});
    }
  }
}
</script>