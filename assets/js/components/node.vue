<template>
  <div class="my-sensors-node card">
      <h1> {{ name && "[" + name + "]" }} {{sketch_name}}  </h1>
      <div v-if="battery_level">
        <strong> battery-level </strong> {{ battery_level }}
      </div>

      <div>
        <strong> Status </strong> {{ status }}
      </div>

      <Sensor v-for="sensor in sensors" v-if="sensor.child_sensor_id != 255"
        :key="sensor.child_sensor_id" 
        :type="sensor.type"
        :node_id="id"
        :child_sensor_id="sensor.child_sensor_id"
      />
  </div>
</template>

<script src="./node.ts" />