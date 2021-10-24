import Vue from 'vue'
import VueRouter from 'vue-router'
// import Home from '../views/Home.vue'
import UserList from '../views/UserList.vue'
import ChatBoard from '../views/ChatBoard.vue'
Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'UserList',
    component: UserList
  },
  {
    path: '/chat',
    name: 'ChatBoard',
    component: ChatBoard
  },
  {
    path: '/about',
    name: 'About',
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import(/* webpackChunkName: "about" */ '../views/About.vue')
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
