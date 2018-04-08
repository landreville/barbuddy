// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue';
import VueScrollTo from 'vue-scrollto';
import BarchefApp from './App';
import router from './router';
import '../node_modules/@fortawesome/fontawesome';

Vue.config.productionTip = false;

Vue.use(VueScrollTo);

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  components: { BarchefApp },
  template: '<barchef-app></barchef-app>',
});
