import Vue from "vue";
import VueRouter from "vue-router";
import Home from "../views/Home.vue";
// import UserList from '../views/UserList.vue'
// import ChatBoard from "../views/ChatBoard.vue";
import Meet from "../views/Meet.vue";
import Result from "../views/Result.vue";
import Video from "../views/Video.vue";
import Select from "../views/Select.vue";
Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    name: "Home",
    component: Home,
    props: true,
  },
  {
    path: "/select/:id/:password/meet",
    name: "Meet",
    component: Meet,
    props: true,
  },
  {
    path: "/select/:id/:password/meet/:re",
    name: "Result",
    component: Result,
    props: true,
  },
  {
    path: "/select/:id/:password/video",
    name: "Video",
    component: Video,
    props: true,
  },
  {
    path: "/select/:id/:password",
    name: "Select",
    component: Select,
    props: true,
  },
];

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  routes,
});

export default router;
