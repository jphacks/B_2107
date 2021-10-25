<script>
import { Pie } from 'vue-chartjs'

export default {
    extends: Pie,
    data () {
        return {
            chartData: {
                labels: ['Janualy', 'Februaly', 'March', 'April'],
                datasets: [{
                    backgroundColor: [
                        'rgba(255, 60, 60, 0.3)',
                        'rgba(60, 60, 60, 0.3)',
                        'rgba(60, 255, 60, 0.3)',
                        'rgba(60, 60, 255, 0.3)',
                    ],
                    data: [100, 120, 30, 70]
                }],
            },
            options: {
                title: {
                    display: true,
                    text: 'Pie chart'
                },
            }
        }
    },
    mounted: function() {
        this.renderChart(this.chartData, this.options)
    }
}
</script>