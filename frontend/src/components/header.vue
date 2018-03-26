<template>
  <div>
  <v-navigation-drawer app v-model="drawer">
    <v-list>
      <v-list-tile>
        <v-list-tile-title class="title">
          Cocktail Catalogs
        </v-list-tile-title>
      </v-list-tile>
    </v-list>
    <v-list class="catalog-list">
      <v-divider></v-divider>

      <v-list-tile :to="{ name: 'recipes' }">
        <v-list-tile-content>
          All Recipes
        </v-list-tile-content>
      </v-list-tile>
      <v-list-tile :to="{ name: 'recipes' }">
        <v-list-tile-content>
          Live Recipes
        </v-list-tile-content>
      </v-list-tile>
      <v-list-tile :to="{ name: 'recipes' }">
        <v-list-tile-content>
          Unp
        </v-list-tile-content>
      </v-list-tile>

      <v-list-tile v-for="catalog in catalogs"
                   :catalog="catalog" :key="catalog"
                   :to="{ name: 'recipes' }">
        <v-list-tile-content>{{ catalog }}
        </v-list-tile-content>
      </v-list-tile>

      <v-divider></v-divider>

      <v-list-tile>
        <v-list-tile-content>
          <v-btn color="info" small>Add Catalog</v-btn>
        </v-list-tile-content>
      </v-list-tile>
    </v-list>
  </v-navigation-drawer>
  <v-toolbar fixed app>
    <v-toolbar-side-icon @click.stop="drawer = !drawer"></v-toolbar-side-icon>
    <v-toolbar-title>Bar Chef</v-toolbar-title>
    <v-spacer></v-spacer>
    <!--<v-toolbar-items class="hidden-sm-and-down">-->
      <!--<v-btn flat>Search</v-btn>-->
    <!--</v-toolbar-items>-->
  </v-toolbar>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'app-header',
  data() {
    return {
      site_title: 'Bar Chef',
      catalogsUrl: 'http://localhost:4000/api/admin/catalogs/',
      drawer: false,
      catalogs: []
    };
  },
  created() {
    this.fetchCatalogs();
  },
  methods: {
    fetchCatalogs() {
      axios.get(this.catalogsUrl).then(
        (response) => { this.catalogs = response.data.data; }
      );
    }
  }
};
</script>

<style scoped>
  .toolbar__title {
    font-family: "Josefin Sans", sans-serif;
    font-weight: bold;
    font-size: 2rem;
    padding-top: 10px;
  }
  .title{
    font-family: "Josefin Slab", sans-serif;
    font-weight: bold;
    padding: 2rem 0;
  }
</style>
