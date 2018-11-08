// import '@ionic/core/css/ionic.bundle.css'
import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from "./pages/home.vue"
import Nodes from "./pages/nodes.vue"
import Graph from "./pages/graph.vue"
import { Socket } from "phoenix"

let socket = new Socket("/socket", { params: {} })
socket.connect();
Vue.config.ignoredElements = [/^ion-/]
Vue.use(VueRouter)

const routes = [
  { path: '/', component: Home },
  { path: '/nodes', component: Nodes },
  { path: '/nodes/:node_id/sensors/:sensor_id/graph', component: Graph }
]

const router = new VueRouter({ routes });
const app = new Vue({ router }).$mount('#app');
Vue.prototype.$socket = socket;
