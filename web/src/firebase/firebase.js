import firebase from "firebase/compat/app";
import "firebase/firestore";
if (!firebase.apps.length) {
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
}

export default firebase;
