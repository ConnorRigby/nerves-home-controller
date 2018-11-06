<template>
  <ion-item>
    <ion-label> 
      <ion-icon :name="type_icon" /> 
      <strong> {{ type_name }}:  </strong> 
    </ion-label>
    {{ real_value }} {{ type_units }} 
    <br> {{ real_inserted_at }}
  </ion-item>
</template>

<script src="./sensor_value.ts" />