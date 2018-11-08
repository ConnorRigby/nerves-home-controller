<template>
  <router-link :to="graph_url" class="ion-button icon-start">
    <ion-icon :name="type_icon" /> 
    <strong> {{ type_name }}:  </strong> 
    {{ real_value }} {{ type_units }}  
  </router-link>
</template>

<script src="./sensor_value.ts" />