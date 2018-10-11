
export default {
  name: "SensorValue",
  components: {},
  props: [
    "node_id",
    "sensor_id",
    "child_sensor_id",
    "type",
    "inserted_at",
    "value"
  ],
  data: function (): {} {
    return {
      real_value: null,
      real_type: null,
      real_inserted_at: null
    };
  },
  methods: {},
  mounted() {
    this.real_value = this.value;
    this.real_type = this.type;
    this.real_inserted_at = this.inserted_at
  },
  created() {
    let channel = this.$socket.channel("sensor_values:" + this.sensor_id.toString(), { sensor_id: this.sensor_id });
    channel.on("sensor_value", (msg: any) => {
      this.real_value = msg.value;
      this.real_type = msg.type;
      this.real_inserted_at = msg.inserted_at
      console.log("Got message", msg)
    });
    channel.join()
      .receive("ok", ({ messages }) => console.log("catching up", messages))
      .receive("error", ({ reason }) => console.log("failed join", reason))
      .receive("timeout", () => console.log("Networking issue. Still waiting..."))
  }
};