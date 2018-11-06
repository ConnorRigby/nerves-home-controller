<template>
    <ion-card class="my-sensors-node">
      <ion-card-title> {{ name && "[" + name + "]" }} {{sketch_name}}  </ion-card-title>
      <ion-card-header> <strong> Status </strong> {{ status }} </ion-card-header>
      <Sensor v-for="sensor in sensors" v-if="sensor.child_sensor_id != 255"
        :key="sensor.child_sensor_id"
        :type="sensor.type"
        :node_id="id"
        :id="sensor.id"
        :child_sensor_id="sensor.child_sensor_id"
      />
    </ion-card>
</template>

<script src="./node.ts" />
