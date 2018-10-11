<template>
  <div class="my-sensors-sensor-value">
    <div> 
      <strong> type: </strong> {{ real_type }}
      <strong> value: </strong> {{ real_value }}
      <strong> updated: </strong> {{ real_inserted_at }}
    </div>
  </div>
</template>

<script src="./sensor_value.ts" />