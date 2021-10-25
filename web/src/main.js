import Vue from "vue";
import App from "./App.vue";
import vuetify from "./plugins/vuetify";
import router from "./router";
import firebase from "firebase/compat";
import "firebase/firestore";

var firebaseConfig = {
  apiKey: process.env.FIREBASE_APIKEY,
  authDomain: process.env.AUTHDOMAIN,
  databaseURL: process.env.DATABASEURL,
  projectId: process.env.PROJECTID,
  storageBucket: process.env.STORAGEBUKET,
  messagingSenderId: process.env.MESSAGEINGSENDERID,
  appId: process.env.APPID,
  measurementId: process.env.MEASUREMENTID,
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
