<template>
  <div class="recipes">
    <div class="card"
         v-on:click="navigateToRecipe(recipe)"
         v-for="recipe in recipes"
         :recipe="recipe"
         :key="recipe.recipe_name">
      <div class="card__banner">
        <img class="main-image" :src="photoUrl(recipe)"/>
      </div>
      <div class="card__content">
        <div class="card__title">
          <h2 class="title">{{ recipe.recipe_name }}</h2>
        </div>
        <div class="card__body">
          <div class="description">
            {{ recipe.description }}
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.recipes{
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  justify-content: center;
  align-items: flex-start;
}

.card{
  width: 300px;
  margin: 2rem;

  border: 1px solid rgba(180, 180, 180, 0.5);
  box-shadow: 0 2px 2px rgba(180, 180, 180, 0.8);

  background-color: white;

  cursor: pointer;
}

.card:hover{
  box-shadow: 0 6px 12px rgba(180, 180, 180, 0.8);
}

.card__banner{
  height:200px;
}

.main-image{
  width: 100%;
}

.title{
  font-family: "Josefin Slab", sans-serif;

  font-size: 1.5rem;
  line-height: 2rem;

  padding: 0;
  margin: 1rem 0 0.5rem 0;

  color: rgb(68, 68, 68);
}

.card__content{
  padding: 0 1rem 2rem 1rem;
}

.description{
  line-height: 1.5rem;
  color: rgb(120, 120, 120);
}
</style>

<script>
import ApiClient from '../lib/apiclient';

export default {
  name: 'recipes',
  created() {
    this.fetchRecipes();
  },
  data() {
    return {
      recipes: [],
    };
  },
  methods: {
    fetchRecipes() {
      ApiClient.getRecipes().then((resp) => { this.recipes = resp.data.data; });
    },
    photoUrl(recipe) {
      return ApiClient.recipeImageUrl(recipe);
    },
    navigateToRecipe(recipe) {
      this.$router.push({ name: 'recipe', params: { id: recipe.recipe_name } });
    }
  },
};
</script>
