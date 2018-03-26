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
import ApiClient from '../lib/apiclient';

export default {
  name: 'recipes',
  created() {
    this.fetchInitialRecipes();
  },
  data() {
    return {
      recipes: [],
      lastkey: null,
      fetching: null
    };
  },
  methods: {
    fetchInitialRecipes() {
      ApiClient.getRecipes((resp) => { this.recipes = resp.data.data; });
    },
    getThumbnailUrl(recipe) {
      if (recipe.thumbnail) {
        return `${ApiClient.recipeBaseUrl}/${recipe._id}/image/${recipe.thumbnail}`;
      }
      return '';
    }
  },
};
</script>
