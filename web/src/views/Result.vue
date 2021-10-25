<template>
  <div>
  
    <template v-for="item in dataSetsKey">
      <label
        :for="`check_${item.index}`"
        :key="item.label"
        :style="`color: ${item.color}; margin: 8px;`"
        ><input
          :id="`check_${item.index}`"
          type="checkbox"
          v-model="filterItem"
          :value="item.index"
        />{{ item.label }}</label
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
       vote:[],
       votes:[],
    };
    
  },
   created() {
     this.votes.push(this.$route.params.re)
     setTimeout(this.fillData(), 3000);
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
        labels: ["A案", "B案", "C案", "D案", "E案"],
        datasets: [
          {
            label: "投票結果",
            backgroundColor: "#4cc36b",
            dataCategory: "vegetable",
            data: [
              this.getRandomInt(),
              this.getRandomInt(),
              this.getRandomInt(),
              this.getRandomInt(),
              this.getRandomInt(),
              this.getRandomInt(),
            ],
          },
        ],
      };
    },
    
    getRandomInt() {

    
      return this.votes[0];
    },
  },
};
</script>