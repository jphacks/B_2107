<template>
  <v-app id="inspire">
    <v-app-bar
      app
      shrink-on-scroll
    >
      <v-app-bar-nav-icon></v-app-bar-nav-icon>
       <v-col
            v-for="(data,index) in agenda"
            :key="index"
          >
      <v-toolbar-title>{{data.agenda}}</v-toolbar-title>
       </v-col>
      <v-spacer></v-spacer>

      <v-btn icon>
        <v-icon>mdi-dots-vertical</v-icon>
      </v-btn>
    </v-app-bar>

    <v-main>
      <v-container>
        <v-row>
          <v-col
            v-for="(data,index) in opinions"
            :key="index"
            cols="4"
          >
             <v-card
    class="mx-auto"
    color="#26c6da"
    dark
    max-width="300"
  >
    <v-card-title>
      <span class="text-h7 font-weight-light">opinion</span>
    </v-card-title>
    <v-card-text class="text-h5 font-weight-bold">
                         {{data.opinion}}
    </v-card-text>
    <v-card-actions>
      <v-list-item class="grow">
        <v-list-item-avatar color="grey darken-3">
          <v-img
            class="elevation-6"
            :src="data.user_image"
          ></v-img>
        </v-list-item-avatar>

        <v-list-item-content>
          <v-list-item-title>{{data.user_name}}</v-list-item-title>
        </v-list-item-content>

        <v-row
          align="center"
          justify="end"
        >
          <v-icon class="mr-1">
            mdi-heart
          </v-icon>
          <span class="subheading mr-2">{{data.opinion_good.length}}</span>
        </v-row>
      </v-list-item>
    </v-card-actions>
  </v-card>
          </v-col>
        </v-row>
      
      </v-container>
      <v-col>

<v-btn
  color="accent"
  depressed
  elevation="10"
  large
  x-large
  @click="result"
>投票結果を見る</v-btn>
      </v-col>
 
    </v-main>
 
    
  </v-app>
  
</template>

<script>

import firebase from "@/firebase/firebase.js";

  export default {

    async created(){
      //初めにfirebaseを取得する処理
    const db = firebase.firestore();
    
   db.collection("opinions").where("room_id","==",Number(this.$route.params.id)).where("password","==",Number(this.$route.params.password))
  .onSnapshot(snapshot => {
    
    snapshot.docChanges().forEach(change => {
      
      if (change.type === "added") {
        
        // 保存済みのデータ n 件分出力される
       this.opinions.push(change.doc.data())

         this.after.push(change.doc.id)
      }

      else if(change.type === 'modified' ) {

    for(let i = 0; i < this.opinions.length; i++) {
      if(change.doc.id==this.after[i]){
       this.opinions.splice(i, 1, change.doc.data())
      }
    }
      }
    });

  });
   db.collection("mtg")
  .where("room_id","==",Number(this.$route.params.id)).where("password","==",Number(this.$route.params.password))
  .onSnapshot(snapshot => {
    snapshot.docChanges().forEach(change => {
      if (change.type === "added") {
        // 保存済みのデータ n 件分出力される
       this.agenda.push(change.doc.data())
      }
       else if(change.type === 'modified' ){
       this.agenda.splice(0, 1, change.doc.data())
        }
    });
  });
    const enter= db.collection('opinions');
    const snapshot = enter.where("room_id","==",62885138).where("password","==",7139).get();
    snapshot.forEach(doc =>{
      this.vote.push(doc.data(""))
    });
   for(const i of this.vote){
       this.votes.push(i.vote_user)
   }

},
    data: () => ({
      opinions: [
      ],
      agenda: [
      ],
      after:[

      ],
      vote:[

      ],
      votes:[1

      ]
    }),
    computed: {

    },
    methods: {
      result(){
        this.$router.push({name:"Result", params: {id: this.$route.params.id, password: this.$route.params.password, re : this.votes[0]}}).catch(() => {});
      }
    }
  }
</script>
<style scoped>
.v-btn{
position: absolute;
bottom: 10px;
margin-left: auto;
margin-right: auto;
}
</style>

