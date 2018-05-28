<template>
  <div class="app">
    <app-header :title="title"></app-header>
    <div class="sidebar">
      <recipe-search @submit="search"></recipe-search>
      <ingredient-pantry @changed="pantryChanged"></ingredient-pantry>
    </div>
    <div class="body">
      <router-view></router-view>
    </div>
  </div>
</template>

<script>
import { APP_TITLE } from '@/lib/constants';
import { ApiClient } from './lib/apiclient';
import { store } from './lib/store';
import appheader from './components/app-header';
import recipesearch from './components/recipe-search';
import pantry from './components/pantry';

export default {
  name: 'barchef-app',
  components: {
    'app-header': appheader,
    'recipe-search': recipesearch,
    'ingredient-pantry': pantry
  },
  created() {
    store.load();
    this.fetchRecipes();
  },
  data() {
    return {
      title: APP_TITLE,
      recipes: [],
    };
  },
  methods: {
    fetchRecipes() {
      // Check if search object is empty ( I sure do like Javascript :S )
      if (Object.keys(store.data.search).length === 0 && store.data.search.constructor === Object) {
        ApiClient.getRecipes().then(data => store.setRecipes(data));
      } else {
        this.search(store.data.search);
      }
    },
    search(searchQuery) {
      if (searchQuery.pantry && searchQuery.pantry.length === 0) {
        store.setRecipes([]);
      } else {
        ApiClient.getRecipes(searchQuery).then(data => store.setRecipes(data));
      }
    },
    pantryChanged() {
      if (store.data.search.hasOwnProperty('pantry')) {
        this.search(store.data.search);
      }
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

.recipe-search{
  border-bottom: 1px solid rgb(200, 200, 200);
}

.pantry{
  margin-top: 1rem;
}

.body{
  grid-column: 2/5;
  grid-row: 2;
}
</style>
