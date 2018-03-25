<template>
  <v-app>
    <app-header></app-header>
    <v-content>
      <v-container>
        <router-view></router-view>
      </v-container>
    </v-content>
  </v-app>
</template>

<script>
import header from './components/header';

export default {
  name: 'barchef-app',
  components: { 'app-header': header }
};
</script>

<style>
  #app {
    font-family: 'Avenir', Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    text-align: center;
    color: #2c3e50;
  }

  .container{
    padding: 0;
  }

</style>
