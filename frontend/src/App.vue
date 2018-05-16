<template>
  <div class="app">
    <app-header :title="title"></app-header>
    <router-view></router-view>
  </div>
</template>

<script>
import { appTitle } from '@/lib/constants';
import appheader from './components/app-header';

export default {
  name: 'barchef-app',
  components: { 'app-header': appheader },
  data() {
    return {
      title: appTitle
    };
  }
};
</script>

<style>
@import 'assets/css/bundle.css';
</style>
