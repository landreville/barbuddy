<template>
  <div>
    <v-list two-line>
      <template
        v-for="(item, index) in recipes"
        :item="item">

        <v-list-tile class="list-tile" avatar :index="index" :key="item._id">

          <!-- TODO: Change to square image -->

          <v-list-tile-avatar>
            <img :src="getThumbnailUrl(item)">
          </v-list-tile-avatar>

          <v-list-tile-content>
            <v-list-tile-title>
              <router-link :to="{name: 'recipe', params: { id: item._id }}">
                {{ item.name }}
              </router-link>
            </v-list-tile-title>
            <v-list-tile-sub-title>{{ item.description }}</v-list-tile-sub-title>
          </v-list-tile-content>

        </v-list-tile>
        <v-divider :key="index"></v-divider>
      </template>
    </v-list>
  </div>
</template>

<style scoped>
  .avatar img{
    border-radius: 5px;
  }
</style>

<script>
import axios from 'axios';

export default {
  name: 'recipes',
  created() {
    this.fetchInitialRecipes();
  },
  data() {
    return {
      recipes: [],
      lastkey: null,
      recipesUrl: 'http://localhost:4000/api/admin/recipes',
      recipeUrl: 'http://localhost:4000/api/admin/recipe',
      fetching: null
    };
  },
  methods: {
    fetchInitialRecipes() {
      this.fetching = axios.get(
        this.recipesUrl,
        { params: { limit: this.limit } }
      ).then((response) => {
        this.saveLastKey(response);
        this.fetching = null;
        this.recipes = response.data.data;
      });
    },
    getThumbnailUrl(recipe) {
      if (recipe.thumbnail) {
        return `${this.recipeUrl}/${recipe._id}/image/${recipe.thumbnail}`;
      }
      return '';
    },
    saveLastKey(response) {
      if (response.data && response.data.length > 0) {
        this.lastkey = JSON.stringify(
          response.data[response.data.length - 1].key
        );
      }
    }
  },
};
</script>
