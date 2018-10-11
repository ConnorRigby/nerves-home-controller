import SensorValue from "./sensor_value.vue";
import axios from "axios";

export default {
  name: "Sensor",
  components: { SensorValue },
  props: ["node_id", "child_sensor_id", "type"],
  data: function (): { latest_sensor_value: [any] } {
    return { latest_sensor_value: null };
  },
  methods: {
    toggle: function (event: any) {
      let that = this;
      console.log(event.target.checked);
      let toggle_state = event.target.checked ? 0 : 1
      let url = "/api/my_sensors/nodes/" + that.node_id.toString() + "/sensors/" + that.child_sensor_id + "/value_status/" + toggle_state.toString();
      axios
        .get(url)
        .then(function (data: any) {

        })
    }
  },
  mounted() {
    var that = this;
    let url = "/api/my_sensors/nodes/" + that.node_id.toString() + "/sensors/" + that.child_sensor_id + "/sensor_values/latest";
    axios
      .get(url)
      .then(function (sensor_value_data: { data: { data: Object } }) {
        if (sensor_value_data.data.data) {
          console.log("sensor_value_data is not null: " + + that.node_id.toString() + ' ' + that.child_sensor_id.toString());
          that.latest_sensor_value = sensor_value_data.data.data;
        } else {
          console.error("DATA IS NULL: " + that.node_id.toString() + ' ' + that.child_sensor_id.toString())
          throw ("YOU EFFED UP")
        }
      })
      .catch((err: any) => {
        console.error(err);
      })
  },
  created() { }
};