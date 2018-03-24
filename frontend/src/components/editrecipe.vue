<template>
  <v-card>
    <v-card-media src="">
    </v-card-media>
    <v-card-title primary-title>
      <h1 class="recipe-title">{{ recipe.name }}</h1>
    </v-card-title>

    <v-form>
      <div class="card-body">
        <v-text-field label="Title" v-model="recipe.name"></v-text-field>
        <v-text-field label="Description" v-model="recipe.description"></v-text-field>

        <div class="ingredients">
          <h2 class="ingredient-subtitle">Ingredients</h2>
          <ul class="ingredient-list">
            <li class="ingredient"
                v-for="(ingredient, index) in recipe.ingredients"
                :ingredient="ingredient"
                :key="index">

              <edit-ingredient
                :ingredient.sync="ingredient"
                :ingredient-items="ingredients"
                :unit-items="unitItems"/>

            </li>
            <li class="ingredient"
                v-for="(ingredient, index) in newIngredients"
                :ingredient="ingredient"
                :key="index + '-new'">
              <edit-ingredient
                :ingredient.sync="ingredient"
                v-on:change="newIngredientChanged"
                :ingredient-items="ingredients"
                :unit-items="unitItems"/>
            </li>
          </ul>
        </div>
        <div class="directions">
          <h2 class="ingredient-subtitle">Directions</h2>
          <v-text-field multi-line v-model="recipe.directions" label="Directions">
          </v-text-field>
        </div>
      </div>

      <v-card-actions>
        <v-btn color="success" @click="save">Save</v-btn>
      </v-card-actions>
    </v-form>
  </v-card>
</template>

<style scoped>
  .card__title{
    padding:2rem;
  }
  .card-body{
    text-align: left;
    padding: 2rem;
  }
  .card__actions{
    padding: 1rem 2rem;
    border-top: 2px solid rgb(240, 240, 240);
  }
  .recipe-title{
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

</style>

<script>
import axios from 'axios';
import editingredient from './editingredient';

export default {
  name: 'editrecipe',
  props: ['id'],
  components: {
    editingredient,
    'edit-ingredient': editingredient },
  data() {
    return {
      recipe: {},
      recipeUrl: 'http://localhost:4000/api/admin/recipe/',
      ingredientsUrl: 'http://localhost:4000/api/admin/ingredients/',
      units: {
        ounce: 'oz',
        cube: 'cubes',
        cup: 'cups',
        dash: 'dashes',
        drop: 'drops',
        leaf: 'leaves',
        slice: 'slices',
        splash: 'splashes',
        sprig: 'sprigs',
        tablespoon: 'tablespoons',
        teaspoon: 'teaspoons',
      },
      unitItems: [],
      ingredients: [],
      newIngredients: [{}],
    };
  },
  watch: {
    $route: 'fetchRecipe'
  },
  created() {
    this.fetchRecipe();
    this.fetchIngredients();
    this.unitItems = this.parseUnitItems(this.units);
  },
  methods: {
    newIngredientChanged() {
      let emptyCount = 0;
      for (let i = this.newIngredients.length - 1; i >= 0; i--) {
        let ing = this.newIngredients[i];
        if (!(ing.name)) {
          emptyCount++;
        }
      }
      if (emptyCount === 0) {
        this.newIngredients.push({});
      }
    },
    fetchIngredients() {
      axios.get(this.ingredientsUrl).then(
        (response) => { this.ingredients = response.data.data; }
      );
    },
    fetchRecipe() {
      axios.get(
        this.recipeUrl + this.$route.params.id
      ).then(
        (response) => {
          this.recipe = response.data.data;
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
      if (unit in this.units) {
        return this.units[unit];
      }
      return unit;
    },
    parseUnitItems(units) {
      const items = [];
      const unitKeys = Object.keys(units);
      for (let i = 0; i < unitKeys.length; i++) {
        const single = unitKeys[i];
        const plural = units[single];

        items.push({ value: single, text: plural });
      }
      return items;
    },
    save(event) {
      event.preventDefault();
      let saveDoc = Object.assign({}, this.recipe);
      saveDoc.ingredients.concat(this.newIngredients.filter(el => el.name));
      // TODO: submit document
      this.$router.push({ name: 'recipe', params: { id: saveDoc.id } });
    }
  }
};
</script>

