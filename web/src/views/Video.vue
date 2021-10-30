<template>
  <div id="Video" class="container wrapper">
    <Header />
    <div class="room">
      <div class="screen">
        <div>
          <video id="js-local-stream" autoplay muted playsinline></video>
        </div>
        <div class="remote-streams" id="js-remote-streams"></div>
      </div>
    </div>
    <div class="controller">
      <v-btn @click="join" x-large outlined color="#00AA6E">参加</v-btn>
      <v-btn @click="leave" x-large outlined color="#00AA6E">退出</v-btn>
      <v-btn @click="shareScreen" x-large outlined color="#00AA6E"
        >画面共有</v-btn
      >
      <v-btn @click="tomeet" x-large outlined color="#00AA6E"
        >議題と意見を表示する</v-btn
      >
      <div class="timeMessage">
        {{ timeMessage }}
      </div>
    </div>
  </div>
</template>
<script src="//cdn.webrtc.ecl.ntt.com/skyway-4.4.2.js"></script>
<script>
import Header from "../components/layout/Header.vue";
import Peer from "skyway-js";
export default {
  components: {
    Header,
  },
  name: "Video",
  data() {
    return {
      roomId: "",
      timeMessage: "",
      localStream: "",
      peerId: "",
      peer: "",
      room: "",
      remoteVideos: "",
    };
  },
  // メディアの許可を求める
  mounted() {
    navigator.mediaDevices
      .getUserMedia({
        audio: true,
        video: true,
      })
      .then((stream) => {
        const localVideo = document.getElementById("js-local-stream");
        localVideo.muted = true;
        localVideo.srcObject = stream;
        localVideo.playsInline = true;
        localVideo.play();
        this.localStream = stream;
      })
      .catch(console.error);

    // Peer作成
    this.peer = new Peer({
      key: process.env.VUE_APP_SKYWAY_KEY,
      debug: 3,
    });
  },
  methods: {
    join: function() {
      this.roomId = this.$route.params.id;
      this.room = this.peer.joinRoom(this.roomId, {
        mode: "sfu",
        stream: this.localStream,
      });

      // 新規に Peer がルームへ入室
      this.room.once("open", () => {
        this.timeShow("あなたが参加しました");
      });

      // ルームに新しい Peer が参加
      this.room.on("peerJoin", () => {});
      // ルームに参加している他のユーザのストリームを受信
      this.room.on("stream", async (stream) => {
        const newVideo = document.createElement("video");
        newVideo.srcObject = stream;
        newVideo.playsInline = true;

        this.remoteVideos = document.getElementById("js-remote-streams");
        newVideo.setAttribute("dataPeerId", this.peerId);
        this.remoteVideos.append(newVideo);
        await newVideo.play().catch(console.error);
      });
    },
    leave: function() {
      this.room.close();
      this.$router
        .push({
          name: "Select",
          params: {
            id: this.$route.params.id,
            password: this.$route.params.password,
          },
        })
        .catch(() => {});
    },
    shareScreen: function() {
      const stream = navigator.mediaDevices.getDisplayMedia({ video: true });
      const call = this.peer.call(stream);
    },
    tomeet() {
      this.$router
        .push({
          name: "Meet",
          params: {
            id: this.$route.params.id,
            password: this.$route.params.password,
          },
        })
        .catch(() => {});
    },
    timeShow: function(message) {
      this.timeMessage = message;
      setTimeout(() => {
        this.timeMessage = "";
      }, 2000);
    },
  },
};
</script>

<style>
.wrapper {
  max-width: 100%;
  max-height: 100%;
}
.room {
  position: relative;
}

.room > div {
  position: absolute;
  inset: 0;
  margin: auto;
}
.screen {
  max-width: 100%;
  display: grid;
  gap: 10px;
  grid-template-columns: repeat(2, 1fr);
}

.controller {
  position: fixed;
  bottom: 50px;
  left: 50%;
  transform: translateX(-50%);
}
button {
  margin-right: 10px;
  margin-top: 15px;
}

.timeMessage {
  margin-top: 10px;
}
</style>
