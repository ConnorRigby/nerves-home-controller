<template>
  <div class="my-sensors-node">
      <h1> {{item.sketch_name}} </h1>
      <div v-if="item.battery_level">
        <strong> battery-level </strong> {{ item.battery_level }}
      </div>

      <div>
        <strong> Status </strong> {{ item.status }}
      </div>

    <span> --- </span>
  </div>
</template>

<script>
export default {
  name: "Node",
  components: {},
  props: ["item"],
  data: function() {
    return {};
  },
  methods: {},
  mounted() {},
  created() {}
};
</script>
