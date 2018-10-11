import axios from "axios";
import Node from "../components/node.vue";

interface nodes_data {
  nodes: [any],
  sensors: [any]
}
export default {
  name: "Nodes",
  components: {
    Node
  },
  data: function (): nodes_data {
    return {
      nodes: null,
      sensors: null
    };
  },
  methods: {},
  mounted() {
    this.nodes = [];
    axios
      .get("/api/my_sensors/nodes")
      .then((node_data: { data: { data: [any] } }) => {
        var all_nodes = node_data.data.data;
        this.nodes = all_nodes;
      })
      .catch((err: any) => {
        console.error(err);
      });
  },
  created() { }
};