 /* eslint-disable */
<template>
  <v-app id="inspire">
    <v-main>
      <v-container
        class="py-8 px-6"
        fluid
      >
        <v-row>
          <v-col
            v-for="card in cards"
            :key="card"
            cols="12"
          >
            <v-card>
              <v-subheader>{{ card }}</v-subheader>

              <v-list two-line>
                <template v-for="(data,index) in messages">
                  <v-list-item
                    :key="index"
                  >
                    <v-list-item-avatar color="grey darken-1">
                    </v-list-item-avatar>

                    <v-list-item-content>
                      <v-list-item-subtitle class="message">
                       {{data.agenda}}
                      </v-list-item-subtitle>
                    </v-list-item-content>
                  </v-list-item>

                  <v-divider
                    v-if="n !== 6"
                    :key="`divider-${index}`"
                    inset
                  ></v-divider>
                </template>
              </v-list>
            </v-card>
          </v-col>
        </v-row>
      </v-container>
       <v-row>
      <v-col
        cols="12"
        sm="10"
      >
        <v-textarea
        v-model="body"
          class="mx-2"
          label="意見を投稿する"
          rows="1"
          prepend-icon="mdi-comment"
          auto-grow
        ></v-textarea>
           <v-btn
        class="mr-4"
        type="submit"
        :disabled="invalid"
        @click="submit"
      >
        submit
      </v-btn>
      <v-btn @click="clear">
        clear
      </v-btn>
      </v-col></v-row>
    </v-main>
  </v-app>
</template>

<script>
import firebase from "@/firebase/firebase.js";
export default {
  props: {
    id: String,
    password:String
  },
    async created(){
    console.log("call")
    const db = firebase.firestore();
    const enter= db.collection('mtg');
    const snapshot = await enter.where("room_id","==",Number(this.id)).where("password","==",Number(this.password)).get();
    snapshot.forEach(doc =>{
      this.messages.push(doc.data(""))
    })
},
    data: () => ({
      messages: [
      ],
      body: '',
      user_id: '',
      cards: ['この会議'],
      drawer: null,
      links: [
        ['mdi-inbox-arrow-down', 'Inbox'],
        ['mdi-send', 'Send'],
        ['mdi-delete', 'Trash'],
        ['mdi-alert-octagon', 'Spam'],
      ],
    }),
    computed: {
        invalid(){
            if(this.body.length<5){
                return true;
            }
            return false;
        }
    },
    methods:{
        clear(){
            this.body =""
        },
        submit(){
            this.messages.unshift({message: this.body});
            var db = firebase.firestore();
            db.collection("chats").add({
              message: this.body,
              })
this.body =""
        }
    }
  }
</script>

<style scoped>
.message{
    text-align: left;
}
</style>