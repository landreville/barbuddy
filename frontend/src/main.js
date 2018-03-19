// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue';
import VueScrollTo from 'vue-scrollto';
import Vuetify from 'vuetify';
import 'vuetify/dist/vuetify.min.css';
import BarchefApp from './App';
import router from './router';


Vue.config.productionTip = false;

Vue.use(Vuetify);
Vue.use(VueScrollTo);

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  components: { BarchefApp },
  template: '<barchef-app></barchef-app>',
});
