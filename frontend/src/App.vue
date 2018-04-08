<template>
  <div class="app">
    <router-view></router-view>
  </div>
</template>

<script>
import header from './components/header';

export default {
  name: 'barchef-app',
  components: { 'app-header': header }
};
</script>

<style>
@import 'assets/css/bundle.css';
</style>
