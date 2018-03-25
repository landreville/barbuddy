<template>
  <v-card>
    <v-card-media :src="imageUrl" height="600px">
    </v-card-media>
    <v-card-title primary-title>
      <h1 class="ingredient-title">{{ recipe.name }}</h1>
    </v-card-title>

    <div class="card-body">
      <div class="description">
        {{ recipe.description }}
      </div>

      <div class="ingredients">
        <h2 class="ingredient-subtitle">Ingredients</h2>
        <ul class="ingredient-list">
          <li class="ingredient"
              v-for="ingredient in recipe.ingredients"
              :ingredient="ingredient"
              :key="ingredient.name">
            <div class="ingredient-amount">
              {{ formatAmount(ingredient.amount, ingredient.unit) }}
            </div>
            <div class="ingredient-name">{{ ingredient.name }}</div>
          </li>
        </ul>
      </div>
      <div class="directions">
        <h2 class="ingredient-subtitle">Directions</h2>
        <p>
          {{ recipe.directions }}
        </p>
      </div>
    </div>

    <v-card-actions>
      <v-btn color="info" :to="{name: 'editrecipe', params: { id: recipe._id }}">
        Edit
      </v-btn>
    </v-card-actions>
  </v-card>
</template>

<style scoped>
  .card{
    margin-top: 2rem;
  }
  .card__title{
    padding:2rem;
  }
  .card-body{
    text-align: left;
    padding: 2rem;
    padding-top: 0;
  }
  .card__actions{
    padding: 1rem 2rem;
    border-top: 2px solid rgb(240, 240, 240);
  }
  .ingredient-title{
    font-family: "Josefin Slab", sans-serif;
    font-weight: bold;
    font-size: 3rem;
    /* card title has enough padding already */
    padding: 0;
    line-height: 3rem;
  }
  .ingredient-subtitle{
    font-family: "Josefin Slab", sans-serif;
    padding: 1rem 0;
  }
  .ingredient-list{
    list-style-type: none;
  }
  .ingredient{
    padding: 0 1rem;
    display: flex;
  }
  .ingredient-amount{
    width: 150px;
  }
</style>

<script>
import axios from 'axios';

export default {
  props: ['id'],
  data() {
    return {
      recipe: {},
      recipeUrl: 'http://localhost:4000/api/admin/recipe/',
    };
  },
  watch: {
    $route: 'fetchRecipe'
  },
  created() {
    this.fetchRecipe();
  },
  methods: {
    fetchRecipe() {
      axios.get(
        this.recipeUrl + this.$route.params.id
      ).then(
        (response) => {
          this.recipe = response.data.data;
          if (this.recipe.image) {
            this.imageUrl = `${this.recipeUrl}${this.$route.params.id}/image/${this.recipe.image}`;
          }
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

