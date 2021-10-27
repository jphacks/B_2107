<template>
  <div id="Video" class="container wrapper">
    <div class="room">
      <div class="screen">
        <video id="js-local-stream" autoplay muted playsinline></video>
        <div class="remote-streams" id="js-remote-streams"></div>
      </div>

      <div class="controller">
        <v-text-field
          v-model="roomId"
          placeholder="Room ID"
          required
        ></v-text-field>
        <v-btn depressed @click="join">参加</v-btn>
        <v-btn depressed @click="leave">退出</v-btn>
        <v-btn depressed @click="shareScreen">画面共有</v-btn>
      </div>
    </div>
    <div>
      <p>
        {{ timeMessage }}
      </p>
    </div>
  </div>
</template>
<script src="//cdn.webrtc.ecl.ntt.com/skyway-4.4.2.js"></script>
<script>
import Peer from "skyway-js";
export default {
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
    },
    shareScreen: function() {
      const stream = navigator.mediaDevices.getDisplayMedia({ video: true });
      const call = this.peer.call(stream);
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

.container {
  margin-left: auto;
  margin-right: auto;
  width: 980px;
}

.screen {
  max-width: 100%;
  display: grid;
  gap: 8px;
  grid-template-columns: repeat(2, 1fr);
}

button {
  margin-right: 10px;
}
</style>
