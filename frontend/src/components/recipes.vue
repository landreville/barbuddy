<template>
  <div class="recipes-wrapper">
    <div class="recipes">
      <recipe-card
        v-for="recipe in store.recipes"
       :recipe="recipe"
       :key="recipe.recipe_name"></recipe-card>
    </div>
  </div>
</template>

<style scoped>

.recipes-wrapper{
  margin: 0 auto;
  max-width: 1200px;
}

.recipes{
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
}

</style>

<script>
import recipeCard from './recipe-card';
import { store } from '../lib/store';

export default {
  name: 'recipes',
  components: { 'recipe-card': recipeCard },
  data() {
    return {
      store: store.data
    };
  }
};
</script>
