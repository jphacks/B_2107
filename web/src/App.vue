<template>
  <div id="app">
    <div id="nav">
      <!-- <router-link to="/">Home</router-link> |
      <router-link to="/about">About</router-link> -->
    </div>
    <sidebar />
    <router-view/>
  </div>
</template>

<style lang="scss">
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

#nav {
  padding: 30px;

  a {
    font-weight: bold;
    color: #2c3e50;

    &.router-link-exact-active {
      color: #42b983;
    }
  }
}

.grey.darken-1{
  background-color:#42b983 !important;
  border-color:#42b983 !important;
}
.pa-4{
  padding: 16px !important;
}

.user_name{
  padding: 10px !important;
}
</style>

<script>
import Sidebar from '@/components/layout/Sidebar'

  export default {
    components: {
      Sidebar,

    },
    data: () => ({
      drawer: null,
    }),
  }
</script>