// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"
import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from "./pages/home.vue"
import Nodes from "./pages/nodes.vue"

Vue.use(VueRouter)

const routes = [
  { path: '/', component: Home },
  { path: '/nodes', component: Nodes }
]

const router = new VueRouter({ routes })
const app = new Vue({ router }).$mount('#app')
