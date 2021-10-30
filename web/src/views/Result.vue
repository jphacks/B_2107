<template>
<div>
      <Header />
<div id="capture">
 
 <div style="display: flex;">
  <div class="fix">
  <template v-for="item in dataSetsKey">
      <label
        :for="`check_${item.index}`"
        :key="item.label"
        :style="`color: ${item.color}; margin: 8px;`"
        >{{ item.label }}</label>
    </template>
    <div class="graph">
    <BarChart
      :chart-data="filteredDataCollection"
      :options="{
        responsive: true,
        maintainAspectRatio: false,
        labeling: { display: false },
        legend: {
          display: false,
        },
      }"
    />
    </div>
     </div>
    <v-simple-table class="table">
    <template v-slot:default>
      <thead>
        <tr>
          <th class="text-left">
            意見
          </th>
          <th class="text-left">
            票数
          </th>
        </tr>
      </thead>
      <tbody>
        <tr
          v-for="(data,index) in vote"
            :key="index"
        >
          <td>{{data.opinion}}</td>
          <td>{{ data.vote_user }}</td>
        </tr>
      </tbody>
    </template>
  </v-simple-table>
  </div>
   </div>

     <v-btn class="picbtn" x-large color="#4169e1" dark id="save-btn"
    @click="captureImage">
      結果を保存する
    </v-btn>
    <v-btn class="picbtn" x-large color="#008000" dark @click="finish">
      会議を終了する
    </v-btn>
</div>
</template>
<script>
import BarChart from "@/components/BarChart.vue";
import firebase from "@/firebase/firebase.js";
import html2canvas from 'html2canvas';
import Header from "@/components/layout/Header.vue";
export default {
  name: "SandBox",
  components: {
    BarChart,
    Header
  },
 
  data() {
  //  ``
    return {
      datacollection: {},
      filterItem: [],
       votes:[],
       fill:[],
       vote:[],
    };
    
  },
  async created() {
      var a=this.$route.params.re.split(',').map(Number)
     for(let i=0;i<=a.length;i++){
       this.votes.push(a[i])
     }
   const db = firebase.firestore();
   db.collection("opinions").where("room_id","==",Number(this.$route.params.id)).where("password","==",Number(this.$route.params.password)).orderBy('vote_user', 'desc').limit(8)
  .onSnapshot(snapshot => {
    snapshot.docChanges().forEach(change => {
      if (change.type === "added") {
       this.vote.push(change.doc.data())
      }
    });
  });
     this.fillData();
     this.filterItem = this.datacollection.datasets.map((_s, i) => i);
  },
  computed: {
    filteredDataCollection() {
      const collection = {
        ...this.datacollection,
        datasets: this.datacollection.datasets.filter((_s, i) => {
          return this.filterItem.includes(i);
        }),
      };
      return collection;
    },
    dataSetsKey() {
      return this.datacollection.datasets.map((s, i) => ({
        label: s.label,
        index: i,
        color: s.backgroundColor,
      }));
    },
  },
  methods: {
    filterByCategory(category) {
      this.filterItem = this.datacollection.datasets
        .map((s, i) => {
          if (s.dataCategory === category) return i;
          return -1;
        })
        .filter((s) => s >= 0);
    },
    fillData() {
        this.datacollection = {
        labels: [`1位  ${this.votes[0]}票`, `2位  ${this.votes[1]}票`,`3位  ${this.votes[2]}票`, `4位  ${this.votes[3]}票`,`5位  ${this.votes[4]}票`],
        datasets: [
          {
            label: "投票結果",
            backgroundColor: "#4cc36b",
            data:this.votes
          },
        ],
      }
        
        if(this.votes.length==5){
          this.datacollection = {
        labels: [`1位  ${this.votes[0]}票`, `2位  ${this.votes[1]}票`,`3位  ${this.votes[2]}票`, `4位  ${this.votes[3]}票`],
        datasets: [
          {
            label: "投票結果",
            backgroundColor: "#4cc36b",
            data: this.getRandomInt()
          },
        ],
      };
        }
     else if(this.votes.length==4){
          this.datacollection = {
        labels: [`1位  ${this.votes[0]}票`, `2位  ${this.votes[1]}票`,`3位  ${this.votes[2]}票`],
        datasets: [
          {
            label: "投票結果",
            backgroundColor: "#4cc36b",
            data: this.getRandomInt()
          },
        ],
      };
        }
    else if(this.votes.length==3){
          this.datacollection = {
        labels: [`1位  ${this.votes[0]}票`, `2位  ${this.votes[1]}票`],
        datasets: [
          {
            label: "投票結果",
            backgroundColor: "#4cc36b",
            data: this.getRandomInt()
          },
        ],
      };
    }
    else if(this.votes.length==2){
          this.datacollection = {
        labels: [`1位  ${this.votes[0]}票`],
        datasets: [
          {
            label: "投票結果",
            backgroundColor: "#4cc36b",
            data: this.getRandomInt()
          },
        ],
      };
        }
    },
    getRandomInt() {
      return this.votes;
    },
 captureImage () {
      html2canvas(document.querySelector('#capture'),{
        }).
        then((canvas) => {
        const link = document.createElement('a')
        link.href = canvas.toDataURL()
        link.download = `vivistudio_result.png`
        link.click()
      })
    },
 finish(){
    this.$router.push({name:"Hone"}).catch(() => {});
    window.location.reload();
 }
  }
}
</script>
<style scoped>
.graph{
margin-left: 10px;
width: 680px;
height: 400px;
margin-top:10px
}
.fix{
margin-left: 10px;
width: 700px;
height: 400px;
margin-top:60px
}
.table{
margin-top:60px;
margin-left: 10px;
margin-right: 10px;
margin-bottom:80px;
width: 700px;
height: 400px;
}
.picbtn{
  margin-top:100px;
}
</style>