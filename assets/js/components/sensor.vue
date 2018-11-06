<template>
  <ion-item>
    <ion-card-content>
      <h3> <strong> Child Sensor: </strong> {{child_sensor_id}} </h3>

      <SensorValue v-if="latest_sensor_value"
        :node_id="node_id"
        :sensor_id="id"
        :child_sensor_id="child_sensor_id"
        :type="latest_sensor_value.type"
        :inserted_at="latest_sensor_value.inserted_at"
        :value="latest_sensor_value.value"
      />
      <ion-toggle v-if="type == 'sensor_binary'" v-on:click="toggle" />
    </ion-card-content>
  </ion-item>
</template>

<script src="./sensor.ts" />
