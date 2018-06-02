<template>
  <div class="recipe">
    <div class="recipe-card">
      <div class="banner">
        <img class="main-image" :src="photoUrl"/>
      </div>
      <div class="body">
        <h1 class="recipe-name">{{ recipe.recipe_name }}</h1>
        <div class="description">{{ recipe.description }}</div>
        <div class="story">{{ recipe.story }}</div>
        <div class="ingredients">
          <h3 class="ingredient-title subtitle">Ingredients</h3>
          <ul class="ingredient-list">
            <li class="ingredient"
                v-for="ingredient in recipe.recipe_ingredients"
                :ingredient="ingredient"
                :key="ingredient.name">
              <div class="ingredient-amount">
                {{ formatAmount(ingredient.amount, ingredient.unit) }}
              </div>
              <div class="ingredient-name">{{ ingredient.ingredient_name }}</div>
            </li>
          </ul>
        </div>
        <h3 class="directions-title subtitle">Directions</h3>
        <div class="directions">{{ recipe.directions }}</div>
      </div>
    </div>

    <div class="controls">
      <div class="edit" v-if="loggedIn">
        <router-link :to="{ name: 'edit-recipe', params: { id: recipe.recipe_name } }">
          Edit
        </router-link>
      </div>
    </div>
  </div>
</template>

<style scoped>
  .recipe{
    margin: 0 auto 2rem auto;
    max-width: 1000px;
  }
  .recipe-card{
    background-color: white;

    /*box-shadow: 0 2px 4px rgba(180, 180, 180, 0.8);*/
  }
  .main-image{
    width: 100%;
  }
  h1.recipe-name{
    margin: 0;
    padding: 1em 0 0 0;
    line-height: 1em;
  }
  .body{
    padding: 0 2rem 2rem 2rem;
  }
  .description{
    font-style: italic;
    color: rgb(130, 130, 130);
    line-height: 1.5em;
    margin-bottom: 1rem;
  }
  .subtitle{
    font-family: "Josefin Slab", sans-serif;
    padding: 0;
  }
  .ingredient-list{
    list-style-type: none;
    padding: 0;
  }
  .ingredient{
    padding: 0;
    display: flex;
  }
  .ingredient-amount{
    width: 150px;
  }
  .controls{
    text-align: right;
    margin: 0 1rem;
  }
</style>

<script>
import { ApiClient } from '../lib/apiclient';
// import { store } from '../lib/store';

export default {
  props: ['id'],
  data() {
    return {
      recipe: {},
      photoUrl: null
    };
  },
  computed: {
    loggedIn() {
      // TODO: get logged in status
      return true;
      // return store.isLoggedIn();
    }
  },
  watch: {
    $route: 'fetchRecipe'
  },
  created() {
    this.fetchRecipe();
  },
  methods: {
    fetchRecipe() {
      ApiClient.getRecipe(this.$route.params.id).then(
        (recipe) => {
          this.recipe = recipe;
          this.photoUrl = ApiClient.recipeImageUrl(recipe);
        }
      );
    },
    formatAmount(amount, unit) {
      const formattedUnit = unit || '';
      const formattedAmount = amount || '';

      if (amount === 1) {
        return `${formattedAmount} ${this.singleize(formattedUnit)}`;
      }
      return `${formattedAmount} ${this.pluralize(formattedUnit)}`;
    },
    singleize(unit) {
      const map = { ounce: 'oz' };
      if (unit in map) {
        return map[unit];
      }
      return unit;
    },
    pluralize(unit) {
      const map = {
        ounce: 'oz',
        dash: 'dashes',
        splash: 'splashes',
        slice: 'slices',
        leaf: 'leaves',
        sprig: 'sprigs',
        cube: 'cubes',
        drop: 'drops',
        teaspoon: 'teaspoons',
        tablespoon: 'tablespoons',
        cup: 'cups'
      };
      if (unit in map) {
        return map[unit];
      }
      return unit;
    }
  }
};
</script>

