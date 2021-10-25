import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '../views/Home.vue'
// import UserList from '../views/UserList.vue'
import ChatBoard from '../views/ChatBoard.vue'
import Meet from '../views/Meet.vue'
import Result from '../views/Result.vue'
Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home,
    props: true
  },
  {
    path: '/chat',
    name: 'ChatBoard',
    component: ChatBoard,
    props: true
  },
  {
    path: '/meet/:id/:password',
    name: 'Meet',
    component: Meet,
    props: true
  },
  {
    path: '/meet/:id/:password/:re',
    name: 'Result',
    component: Result,
    props: true
  },
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
