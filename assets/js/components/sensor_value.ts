
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
      real_inserted_at: null,
      type_name: "unknown",
      type_units: "units",
      type_icon: "help"
    };
  },
  methods: {},
  mounted() {
    this.real_value = this.value;
    this.real_type = this.type;
    this.real_inserted_at = new Date(this.inserted_at).toISOString();
    let get_type_name = function (name) {
      switch (name) {
        case "value_hum": return "Humidity";
        case "value_temp": return "Temperature";
        default: {
          console.log("unknown type name: " + name);
          return "unknown";
        }
      }
    };

    let get_type_units = function (name) {
      switch (name) {
        case "value_hum": return "%";
        case "value_temp": return "degrees";
        default: {
          console.log("unknown type unit: " + name);
          return "units";
        }
      }
    };

    let get_type_icon = function (name) {
      switch (name) {
        case "value_hum": return "water";
        case "value_temp": return "thermometer";
        default: {
          console.log("unknown type icon: " + name);
          return "help";
        }
      }
    }
    this.type_name = get_type_name(this.real_type);
    this.type_units = get_type_units(this.real_type);
    this.type_icon = get_type_icon(this.real_type);
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