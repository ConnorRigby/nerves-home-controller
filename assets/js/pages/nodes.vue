<template>
  <ul id="my-sensors-nodes">
    <Node 
      v-for="node in nodes" 
      :key="node.id"
      :battery_level="node.battery_level"
      :config="node.config"
      :id="node.id"
      :name="node.name"
      :protocol="node.protocol"
      :sketch_name="node.sketch_name"
      :sketch_version="node.sketch_version"
      :status="node.status"
    />
  </ul>
</template>
<script src="./nodes.ts" />
