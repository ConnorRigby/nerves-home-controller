import axios from "axios";

export default {
  name: "Graph",
  components: {},
  data: function () { return {}; },
  methods: {},
  mounted() { },
  created() {
    let node_id = this.$route.params.node_id;
    let sensor_id = this.$route.params.sensor_id;
    let sensor_url = "/api/my_sensors/nodes/" +
      node_id.toString() +
      "/sensors/" +
      sensor_id.toString();

    let values_url = "/api/my_sensors/nodes/" +
      node_id.toString() +
      "/sensors/" +
      sensor_id.toString() +
      "/sensor_values";
    let sensor = {};
    axios
      .get(sensor_url)
      .then(function (sensor_resp: { data: { data: [any] } }) {
        let sensor = sensor_resp.data.data;
        axios
          .get(values_url)
          .then(function (sensor_values: { data: { data: [any] } }) {
            let ctx = document.getElementById("graph").getContext('2d');
            let sensor_data = [];
            let sensor_labels = [];

            for (let i = 0; i < sensor_values.data.data.length; i++) {
              let localtime = new Date(sensor_values.data.data[i].inserted_at);
              sensor_labels.push(localtime);
            };

            for (let i = 0; i < sensor_values.data.data.length; i++) {
              let t = sensor_values.data.data[i].inserted_at;
              let y = sensor_values.data.data[i].value;
              sensor_data.push({ t, y });
            };

            let myChart = new Chart(ctx, {
              type: 'line',
              data: {
                labels: sensor_labels,
                datasets: [
                  {
                    data: sensor_data,
                    label: sensor["type"],
                    borderColor: "#3e95cd",
                    fill: false
                  }
                ]
              },
              options: {
                scales: {
                  xAxes: [{
                    type: 'time',
                    time: {
                      unit: 'minute'
                    }
                  }]
                }
              }
            });
          });
      })
      .catch((err: any) => {
        console.error(err);
      });
  }
};