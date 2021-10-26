import Vue from "vue";
import App from "./App.vue";
import vuetify from "./plugins/vuetify";
import router from "./router";
import firebase from "firebase/compat";
import "firebase/firestore";

var firebaseConfig = {
  apiKey: process.env.VUE_APP_FIREBASE_APIKEY,
  authDomain: process.env.VUE_APP_AUTHDOMAIN,
  databaseURL: process.env.VUE_APP_DATABASEURL,
  projectId: process.env.VUE_APP_PROJECTID,
  storageBucket: process.env.VUE_APP_STORAGEBUKET,
  messagingSenderId: process.env.VUE_APP_MESSAGEINGSENDERID,
  appId: process.env.VUE_APP_APPID,
  measurementId: process.env.VUE_APP_MEASUREMENTID,
};

firebase.initializeApp(firebaseConfig);
firebase.analytics();

export default firebase;
window.firebase = firebase;
Vue.config.productionTip = false;

new Vue({
  vuetify,
  router,
  firebase,
  render: (h) => h(App),
}).$mount("#app");
