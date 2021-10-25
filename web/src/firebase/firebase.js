import firebase from "firebase/compat/app";
import "firebase/firestore";
if (!firebase.apps.length) {
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
}

export default firebase;
