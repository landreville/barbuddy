<template>
  <div class="recipes-wrapper">
    <div class="recipes">
      <div class="card"
           v-for="recipe in recipes"
           :recipe="recipe"
           :key="recipe.recipe_name">
        <div class="card__banner">
          <img class="main-image" :src="photoUrl(recipe)"/>
        </div>
        <div class="card__content">
          <div class="card__title">
            <h2 class="title">
              <router-link class="title-link"
                           :to="{ name: 'recipe', params: { id: recipe.recipe_name } }">
                {{ recipe.recipe_name }}
              </router-link>
            </h2>
          </div>
          <div class="card__body">
            <div class="description">
              {{ recipe.description }}
            </div>
          </div>
        </div>
      </div>
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

.card{
  width: 360px;
  max-width: 400px;
  min-width: 120px;

  margin: 2rem 1rem;
}

.card__banner{
  height:200px;
}

.card__content{
  padding: 1rem;
}

.main-image{
  width: 100%;
}

.title{
  font-family: "Josefin Slab", sans-serif;
  text-align: center;

  font-size: 1.5rem;
  line-height: 2rem;

  padding: 0;
  margin: 0 0 0.5rem 0;

  color: rgb(75, 75, 75);
}

.title-link{
  color: rgb(68, 68, 68);
}

.title-link:hover{
  text-decoration: underline;
}

.description{
  line-height: 1.5rem;
  color: rgb(120, 120, 120);
}
</style>

<script>
import { ApiClient } from '../lib/apiclient';

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
      console.log(ApiClient.getRecipes);
      ApiClient.getRecipes().then((data) => { this.recipes = data; });
    },
    photoUrl(recipe) {
      return ApiClient.recipeImageUrl(recipe);
    }
  },
};
</script>
