import Sensor from "./sensor.vue";
import axios from "axios";

export default {
  name: "Node",
  components: { Sensor },
  props: [
    "battery_level",
    "config",
    "id",
    "name",
    "protocol",
    "sketch_name",
    "sketch_version",
    "status"],

  data: function (): { sensors: [any] } {
    return { sensors: null };
  },
  methods: {},
  mounted() {
    var that = this;
    axios
      .get("/api/my_sensors/nodes/" + that.id.toString() + "/sensors")
      .then(function (sensor_data: { data: { data: [any] } }) {
        that.sensors = sensor_data.data.data;
      })
      .catch((err: any) => {
        console.error(err);
      })
  },
  created() { }
};