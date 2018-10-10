<template>
<ul id="my-sensors-nodes">
  <Node v-for="item in nodes" :key="item.id" :item = item>
  </Node>
</ul>
</template>

<script>
import axios from "axios";
import Node from "../templates/node.vue";

export default {
  name: "Nodes",
  components: {
    Node
  },
  data: function() {
    return {
      nodes: []
    };
  },
  methods: {},
  mounted() {
    axios.get("/api/my_sensors/nodes").then(data => {
      this.nodes = data.data.data;
    });
  },
  created() {}
};
</script>
