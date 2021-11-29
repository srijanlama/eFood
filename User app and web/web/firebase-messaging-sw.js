importScripts("https://www.gstatic.com/firebasejs/7.20.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/7.20.0/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyBRobgZqIC-dFsr05MzxUQXxQITjKpnDH0",
  authDomain: "emarket-e420c.firebaseapp.com",
  projectId: "emarket-e420c",
  storageBucket: "emarket-e420c.appspot.com",
  messagingSenderId: "151590191214",
  appId: "1:151590191214:web:4e7582ed290b4f60a5667f",
  databaseURL: "...",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});