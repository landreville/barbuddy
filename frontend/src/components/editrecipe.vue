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
        <v-select :items="catalogItems" label="Catalog" v-model="recipe.catalog"></v-select>
        <v-text-field label="Description" v-model="recipe.description"></v-text-field>
        <fileinput accept="image/*" @input="getUploadedFile"/>

        <div class="ingredients">
          <h2 class="ingredient-subtitle">Ingredients</h2>
          <ul class="ingredient-list">
            <li class="ingredient"
                v-for="(ingredient, index) in recipe.ingredients"
                :ingredient="ingredient"
                :key="index">

              <editingredient
                :ingredient.sync="ingredient"
                :ingredient-items="ingredients"
                :unit-items="unitItems"/>

            </li>
            <li class="ingredient"
                v-for="(ingredient, index) in newIngredients"
                :ingredient="ingredient"
                :key="index + '-new'">
              <editingredient
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
import fileinput from './fileinput';

export default {
  name: 'editrecipe',
  props: ['id'],
  components: { editingredient, fileinput },
  data() {
    return {
      recipe: {},
      recipeUrl: 'http://localhost:4000/api/admin/recipe/',
      ingredientsUrl: 'http://localhost:4000/api/admin/ingredients/',
      catalogsUrl: 'http://localhost:4000/api/admin/catalogs/',
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
      catalogItems: []
    };
  },
  watch: {
    $route: 'fetchRecipe'
  },
  created() {
    this.fetchRecipe();
    this.fetchIngredients();
    this.unitItems = this.parseUnitItems(this.units);
    this.catalogItems = this.fetchCatalogs();
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
    fetchCatalogs() {
      axios.get(this.catalogsUrl).then(
        (response) => { this.catalogItems = response.data.data; }
      );
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
    getUploadedFile(e) {
      this.image = e;
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
      axios.put(this.recipeUrl + this.recipe._id, saveDoc).then(
        this.saveImage
      ).then(
        () => this.$router.push({ name: 'recipe', params: { id: this.recipe._id } })
      );
    },
    saveImage() {
      if (!this.image) {
        return;
      }
      let data = new FormData();
      data.append('image', this.image);
      return axios.put(`${this.recipeUrl}${this.recipe._id}/image`, data);
    }
  }
};
</script>

