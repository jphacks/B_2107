<template>
  <v-app id="inspire">
    <v-app-bar
      app
      shrink-on-scroll
    >
      <v-app-bar-nav-icon></v-app-bar-nav-icon>
      <v-toolbar-title class="title"></v-toolbar-title>
      <v-spacer></v-spacer>

      <v-btn icon>
        <v-icon>mdi-dots-vertical</v-icon>
      </v-btn>
    </v-app-bar>

    <v-main>
      <v-col
            v-for="(data,index) in agenda"
            :key="index"
          >
       <v-card
    class="mx-auto agenda"
    color="green"
    dark
    max-width="800"
  >
    <v-card-title >
          <v-dialog
      v-model="dialog"
      persistent
      max-width="600px"
    >
      <template v-slot:activator="{ on, attrs }">
     <v-icon
  color="white"
  x-large
  v-bind="attrs"
  v-on="on"
>mdi-plus</v-icon>
      </template>
         <v-card>
        <v-card-title>
          <span class="text-h5">議題変更</span>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-row>
              <v-col cols="12">
                <v-text-field
                v-model="body"
                  label="議題を入力してください"
                  required
                ></v-text-field>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="blue darken-1"
            text
            @click="dialog_f"
          >
            Close
          </v-btn>
          <v-btn
            color="blue darken-1"
            text
            @click="dialog_t"
          >
            Save
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    </v-card-title>
      <v-row
          align="center"
          justify="end"
        >
    <v-card-text class="text-h3 font-weight-bold">
      {{data.agenda}}
    
    </v-card-text>
      </v-row>
    <v-card-actions>
      <v-list-item class="grow">
        <v-row
          align="center"
          justify="center"
        >
        </v-row>
      </v-list-item>
    </v-card-actions>
  </v-card>
      </v-col>
      <v-container>
        <v-row>
          <v-col
            v-for="(data,index) in opinions"
            :key="index"
            cols="4"
          >
             <v-card
    class="mx-auto"
    color="green"
    dark
    max-width="300"
  >
    <v-card-title>
      <span class="opacity">a</span>
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
  class="vote-btn"
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
       this.id.push(change.doc.id)
      }
       else if(change.type === 'modified' ){
       this.agenda.splice(0, 1, change.doc.data())
        }
    });
  });
    const enter= db.collection('opinions');
    const snapshot =await enter.where("room_id","==",Number(this.$route.params.id)).where("password","==",Number(this.$route.params.password)).orderBy('vote_user', 'desc').limit(5).get();
    snapshot.forEach(doc =>{
      this.vote.push(doc.data(""))
    });
   for(const i of this.vote){
       this.votes.push(i.vote_user)
   }

},
    data: () => ({
      dialog: false,
      opinions: [
      ],
      agenda: [
      ],
      after:[

      ],
      vote:[

      ],
      votes:[

      ],
      id:[

      ],
    }),
    computed: {

    },
    methods: {
      result(){
        var str = this.votes.join(',');
        this.$router.push({name:"Result", params: {id: this.$route.params.id, password: this.$route.params.password, re : str}}).catch(() => {});
         window.location.reload();
      },
      dialog_f(){
        this.dialog=false
      },
      async dialog_t(){
        this.dialog=false;
  const db = firebase.firestore();
const userRef = db.collection('mtg').doc(this.id[0])
await userRef.update({
  agenda: this.body,
});
      },
    }
  }
</script>
<style scoped>
.vote-btn{
position: center;

}
.opacity{
  opacity: 0%;
}
.title{
position: absolute;
margin-bottom: 50%;
margin-left: 40%;
margin-right: 50%;
}
.agenda{
  width:auto;
  height: auto;
}

</style>

