<template>
  <div>
    <v-list two-line>
      <template
        v-for="(item, index) in recipes"
        :item="item">

        <v-list-tile class="list-tile" avatar :index="index" :key="item._id">

          <!-- TODO: Change to square image -->
          <v-list-tile-avatar>
            <img src="/static/photos/cocktails/cocktail.jpg">
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

</style>

<script>
import axios from 'axios';

export default {
  name: 'recipes',
  created() {
    this.fetchInitialRecipes();
  },
  mounted() {
    this.addFetchScrollListener();
  },
  data() {
    return {
      recipes: [],
      lastkey: null,
      recipesUrl: 'http://localhost:4000/api/admin/recipes',
      limit: 25,
      fetching: null
    };
  },
  methods: {
    addFetchScrollListener() {
      document.addEventListener('scroll', () => {
        if (this.fetching) {
          return;
        }
        const offsetHeight = document.documentElement.offsetHeight;
        const windowHeight = window.innerHeight;
        const scrollPos = (
          window.scrollY
          || window.pageYOffset
          || document.body.scrollTop
          + ((document.documentElement && document.documentElement.scrollTop) || 0)
        );
        if (windowHeight + scrollPos >= offsetHeight * 0.75) {
          this.fetchMoreRecipes();
        }
      });
    },
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
    fetchMoreRecipes(event) {
      if (event) {
        event.preventDefault();
      }
      if (this.fetching) {
        return;
      }

      const params = { limit: this.limit, startkey: this.lastkey, skip: 1 };
      this.fetching = axios.get(this.recipesUrl, { params }).then((response) => {
        this.saveLastKey(response);
        this.fetching = null;
        response.data.rows.map(el => this.recipes.push(el));
      });
    },
    saveLastKey(response) {
      if (response.data && response.data.rows && response.data.rows.length > 0) {
        this.lastkey = JSON.stringify(
          response.data.rows[response.data.rows.length - 1].key
        );
      }
    }
  },
};
</script>
