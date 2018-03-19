<template>
  <v-card>
    <v-card-media src=""></v-card-media>
    <v-card-title primary-title>
      <h1 class="headline mb-0">{{ recipe.name }}</h1>
    </v-card-title>

    <div class="card-body body-2">
      <div class="ingredients">
        <h2 class="title">Ingredients</h2>

      </div>
      <div class="directions">
        <h2 class="title">Directions</h2>
        <p>
          {{ recipe.directions }}
        </p>
      </div>
    </div>

    <v-card-actions>

    </v-card-actions>
  </v-card>
</template>

<style scoped>
  .card-body{
    text-align: left;
    padding: 16px;
  }
</style>

<script>
import axios from 'axios';

export default {
  props: ['id'],
  data() {
    return {
      recipe: {},
      recipeUrl: 'http://172.17.0.2:5984/peacock/_design/peacock/_view/recipes-by-id',
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
        this.recipeUrl,
        { params: { key: JSON.stringify(this.$route.params.id) } }
      ).then(
        (response) => {
          this.recipe = this.parseItem(response.data.rows[0]);
        }
      );
    },
    parseItem(item) {
      const recipe = item.value;
      recipe.id = item.id;
      return recipe;
    }
  }
};
</script>

