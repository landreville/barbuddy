<template>
  <div class="recipe">
    <div class="recipe-card">
      <div class="banner">
        <img class="main-image" :src="photoUrl"/>
      </div>

      <div class="body">
        <h1 class="recipe-name">{{ recipe.recipe_name }}</h1>

        <div class="field-group">
          <label class="field-label">Catalog</label>
          <div class="field-control">
            <select v-model="recipe.catalog">
              <option value="">-- Choose Catalog --</option>
              <option v-for="catalog in catalogOptions" :catalog="catalog" :key="catalog">
                {{ catalog }}
              </option>
            </select>
          </div>
        </div>

        <div class="field-group">
          <label class="field-label">Category</label>
          <div class="field-control">
            <select v-model="recipe.category">
              <option value="">-- Choose Category --</option>
              <option v-for="category in categoryOptions" :catalog="category"
                      :key="category">
                {{ category }}
              </option>
            </select>
          </div>
        </div>

        <div class="field-group">
          <label class="field-label">Vessel</label>
          <div class="field-control">
            <select v-model="recipe.vessel">
              <option value="">-- Choose Vessel --</option>
              <option v-for="vessel in vesselOptions" :vessel="vessel" :key="vessel">
                {{ vessel }}
              </option>
            </select>
          </div>
        </div>

        <div class="field-group">
          <label class="field-label">Name</label>
          <div class="field-control">
            <input type="text" v-model.trim="recipe.recipe_name"/>
          </div>
        </div>

        <div class="field-group">
          <label class="field-label">Summary</label>
          <div class="field-control">
            <input type="text" v-model.trim="recipe.description"/>
          </div>
        </div>

        <h3 class="subtitle">Directions</h3>
        <textarea rows="5" v-model="recipe.directions"></textarea>

        <h3 class="subtitle">Ingredients</h3>
        <ul class="ingredient-list">
          <li class="ingredient"
              v-for="(ingredient, index) in recipe.recipe_ingredients"
              :ingredient="ingredient"
              :key="index">

            <editingredient
              :ingredient.sync="ingredient"
              :ingredient-options="ingredientOptions"
              :unit-options="unitOptions"/>

          </li>

          <li class="ingredient"
              v-for="(ingredient, index) in newIngredients"
              :ingredient="ingredient"
              :key="index + '-new'">

            <editingredient
              :ingredient.sync="ingredient"
              v-on:change="newIngredientChanged"
              :ingredient-options="ingredientOptions"
              :unit-options="unitOptions"/>

          </li>
        </ul>

        <div class="field-group">
          <label class="field-label">Photo</label>
          <div class="field-control">
            <input type="file" @change="fileChosen($event)"/>
          </div>
        </div>

        <div class="buttons">
          <button type="submit" @click="save">Save</button>
          <router-link :to="{ name: 'recipe', params: { id: recipe.recipe_name } }">
            Cancel
          </router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
  .recipe {
    margin: 2rem auto;
    max-width: 1000px;
  }

  .recipe-card {
    background-color: white;

    box-shadow: 0 2px 4px rgba(180, 180, 180, 0.8);
  }

  .main-image {
    width: 100%;
  }

  h1.recipe-name {
    margin: 0;
    padding: 1em 0 0 0;
    line-height: 1em;
  }

  .body {
    padding: 0 2rem 2rem 2rem;
  }

  .subtitle {
    font-family: "Josefin Slab", sans-serif;
    padding: 0;
  }

  .ingredient-list {
    list-style-type: none;
    padding: 0;
  }

  .ingredient {
    padding: 0;
    display: flex;
    margin-bottom: 0.5rem;
  }

  textarea, input{
    width: 100%;
  }

  .buttons{
    margin-top: 2rem;
  }

  .field-group{}
</style>

<script>
import ApiClient from '../lib/apiclient';
import editingredient from './editingredient';
import fileinput from './fileinput';

export default {
  name: 'editrecipe',
  props: ['id'],
  components: { editingredient, fileinput },
  data() {
    return {
      recipe: {},
      photoUrl: null,
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
      unitOptions: [],
      ingredientOptions: [],
      newIngredients: [{}],
      catalogOptions: [],
      vesselOptions: [],
      categoryOptions: []
    };
  },
  watch: {
    $route: 'fetchRecipe'
  },
  created() {
    this.fetchRecipe();
    this.fetchIngredients();
    this.unitOptions = this.parseUnitItems(this.units);
    this.fetchCatalogs();
    this.fetchCategories();
    this.fetchVessels();
  },
  methods: {
    newIngredientChanged() {
      let emptyCount = 0;
      for (let i = this.newIngredients.length - 1; i >= 0; i--) {
        let ing = this.newIngredients[i];
        if (!(ing.ingredient_name)) {
          emptyCount++;
        }
      }
      if (emptyCount === 0) {
        this.newIngredients.push({});
      }
    },

    fetchCatalogs() {
      ApiClient.getCatalogs().then(
        (data) => {
          this.catalogOptions = data;
        }
      );
    },

    fetchCategories() {
      ApiClient.getCategories().then(
        (data) => {
          this.categoryOptions = data;
        }
      );
    },

    fetchIngredients() {
      ApiClient.getIngredients().then(
        (data) => {
          this.ingredientOptions = data;
        }
      );
    },

    fetchVessels() {
      ApiClient.getVessels().then(
        (data) => {
          this.vesselOptions = data;
        }
      );
    },

    fetchRecipe() {
      ApiClient.getRecipe(this.$route.params.id).then(
        (data) => {
          this.recipe = data;
          this.photoUrl = ApiClient.recipeImageUrl(data);
        }
      );
    },

    fileChosen(event) {
      this.image = event.target.files[0];
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
      let id = this.$route.params.id;
      let saveDoc = Object.assign({}, this.recipe);
      let newIng = this.newIngredients;

      saveDoc.recipe_ingredients = (
        saveDoc.recipe_ingredients.concat(newIng).filter(el => el.ingredient_name)
      );
      ApiClient.putRecipe(id, saveDoc, this.image).then(
        () => this.$router.push({ name: 'recipe', params: { id } })
      );
    }
  }
};
</script>

