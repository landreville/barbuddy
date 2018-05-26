<template>
  <div class="card"
       >
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
        <div class="ingredients-summary" v-if="mainIngredients.length > 0">
          <div class="main-ing-title">
            Includes
          </div>
          <div class="main-ing-item"
               v-for="mainIng in mainIngredients"
               :key="mainIng.ingredient_name"
               :mainIn="mainIng">
            {{ mainIng.ingredient_name }}
          </div>
        </div>
        <div class="missing-pantry" v-if="missingIngredients.length > 0">
          <div class="missing-pantry-title">
            Missing from Pantry
          </div>
          <div class="missing-item"
             v-for="missingIng in missingIngredients"
             :key="missingIng"
             :missingIng="missingIng">
            {{ missingIng }}
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ApiClient } from '../lib/apiclient';
import { store } from '../lib/store';

export default {
  name: 'recipe-card',
  props: ['recipe'],
  data() {
    return {
      pantryItems: store.data.pantryItems,
    };
  },
  computed: {
    recipeIngredients() { return this.recipe.recipe_ingredients; },
    missingIngredients() {
      if (!this.pantryItems || (this.pantryItems && this.pantryItems.length === 0)) {
        return [];
      }

      let missingIngredients = [];
      for (let i = 0; i < this.recipeIngredients.length; i++) {
        let recipeIngredient = this.recipeIngredients[i];
        if (
          !recipeIngredient.optional && !recipeIngredient.garnish &&
          this.pantryItems.indexOf(recipeIngredient.ingredient_name) === -1
        ) {
          missingIngredients.push(recipeIngredient.ingredient_name);
        }
      }

      return missingIngredients;
    },
    mainIngredients() {
      let mainIngs = [];
      for (let i = 0; i < this.recipeIngredients.length && mainIngs.length < 3; i++) {
        let recipeIngredient = this.recipeIngredients[i];
        if (!recipeIngredient.garnish && !recipeIngredient.optional) {
          mainIngs.push(recipeIngredient);
        }
      }
      return mainIngs;
    }
  },
  methods: {
    photoUrl(recipe) {
      return ApiClient.recipeImageUrl(recipe);
    },
  }
};
</script>

<style scoped>

.card{
  width: 320px;
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
  text-align: center;
}

.missing-pantry-title, .main-ing-title{
  font-size: 0.75rem;
  font-weight: bold;
  line-height: 1rem;
  color: rgb(120, 120, 120);
  margin-top: 0.5rem;

}
.missing-item, .main-ing-item{
  font-size: 0.75rem;
  line-height: 1rem;
  color: rgb(120, 120, 120);
}
</style>
