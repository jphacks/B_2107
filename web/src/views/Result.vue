<template>
  <div>
  <template v-for="item in dataSetsKey">
      <label
        :for="`check_${item.index}`"
        :key="item.label"
        :style="`color: ${item.color}; margin: 8px;`"
        >{{ item.label }}</label
      >
    </template>
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
</template>
<script>
import BarChart from "@/components/BarChart.vue";
// import firebase from "@/firebase/firebase.js";
export default {
  name: "SandBox",
  components: {
    BarChart,
  },
 
  data() {
   
    return {
      datacollection: {},
      filterItem: [],
       votes:[],
    };
    
  },
   created() {
     var a=this.$route.params.re.split(',').map(Number)
     for(let i=0;i<=a.length;i++){
       this.votes.push(a[i])
     }
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
    if(this.votes.length>=6){
          this.datacollection = {
        labels: [`A案  ${this.votes[0]}票`, `B案  ${this.votes[1]}票`,`C案  ${this.votes[2]}票`, `D案  ${this.votes[3]}票`,`E案  ${this.votes[4]}票`],
        datasets: [
          {
            label: "投票結果",
            backgroundColor: "#4cc36b",
            data: this.getRandomInt()
          },
        ],
      };
        }
        if(this.votes.length==5){
          this.datacollection = {
        labels: [`A案  ${this.votes[0]}票`, `B案  ${this.votes[1]}票`,`C案  ${this.votes[2]}票`, `D案  ${this.votes[3]}票`],
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
        labels: [`A案  ${this.votes[0]}票`, `B案  ${this.votes[1]}票`,`C案  ${this.votes[2]}票`],
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
        labels: [`A案  ${this.votes[0]}票`, `B案  ${this.votes[1]}票`],
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
        labels: [`A案  ${this.votes[0]}票`],
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
  },
};
</script>