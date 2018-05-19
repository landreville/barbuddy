<template>
  <div class="app">
    <app-header :title="title"></app-header>
    <div class="sidebar">
      <recipe-search @submit="search"></recipe-search>
    </div>
    <div class="body">
      <router-view></router-view>
    </div>
  </div>
</template>

<script>
import { appTitle } from '@/lib/constants';
import { ApiClient } from './lib/apiclient';
import { store } from './lib/store';
import appheader from './components/app-header';
import recipesearch from './components/recipe-search';

export default {
  name: 'barchef-app',
  components: { 'app-header': appheader, 'recipe-search': recipesearch },
  created() {
    this.fetchRecipes();
  },
  data() {
    return {
      title: appTitle,
      recipes: [],
    };
  },
  methods: {
    fetchRecipes() {
      ApiClient.getRecipes().then(data => store.setRecipes(data));
    },

    search(searchQuery) {
      store.setSearch(searchQuery);
      ApiClient.getRecipes(searchQuery).then(data => store.setRecipes(data));
    }
  },
};
</script>

<style>
@import 'assets/css/bundle.css';

.app{
  display: grid;

  grid-template-columns: repeat(4, 1fr);
  grid-gap: 0;
  grid-auto-rows: 1fr auto;
}

header{
  grid-column: 1/5;
  grid-row: 1;
}

.sidebar{
  grid-column: 1;
  grid-row: 2;

  border-right: 1px solid rgb(200, 200, 200);
}

.body{
  grid-column: 2/5;
  grid-row: 2;
}
</style>
