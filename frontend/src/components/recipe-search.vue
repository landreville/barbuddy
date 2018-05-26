<template>
  <div class="recipe-search">
    <h2>Filter Recipes</h2>
    <div class="search-fields">
      <form>
      <div class="search-field">
        <input class="search-input basic" type="text" ref="searchInput"
               placeholder="Search..."
               v-model="q"
               @change="change"/>
      </div>
      <div class="search-field">
        <multiselect class="search-input ingredients"
                     v-model="ingredients"
                     :options="ingredientOptions"
                     :multiple="true"
                     deselectLabel=""
                     selectLabel=""
                     placeholder="Ingredients..."
                     @search-change="change">
        </multiselect>
      </div>
      <div class="search-field">
        <label class="checkbox-label">
          <input class="in-pantry" type="checkbox" v-model="inPantry" @change="change"/>
          Recipes I can make
        </label>
      </div>
      <div class="search-field search-buttons">
        <button type="submit" class="search-button submit" @click.prevent="submit">
          Search
        </button>
        <button type="reset" class="search-button reset" @click.prevent="reset">
          Clear
        </button>
      </div>
      </form>
    </div>
  </div>
</template>

<script>
import Multiselect from 'vue-multiselect';
import { ApiClient } from '../lib/apiclient';
import { store } from '../lib/store';

export default {
  name: 'recipe-search',
  components: { Multiselect },
  created() {
    this.fetchIngredients();
  },
  mounted() {
    this.$refs.searchInput.focus();

    let savedSearch = store.data.search;
    if (savedSearch.q) {
      this.q = savedSearch.q;
    }
    if (savedSearch.pantry) {
      this.inPantry = true;
    }
    if (savedSearch.ingredients) {
      this.ingredients = savedSearch.ingredients;
    }
  },
  data() {
    return {
      ingredientOptions: [],
      ingredients: null,
      inPantry: false,
      q: null,
      searchQuery: store.data.search
    };
  },
  methods: {
    fetchIngredients() {
      ApiClient.getIngredients().then(
        (data) => {
          this.ingredientOptions = data;
        }
      );
    },
    buildSearch() {
      let searchQuery = {
        q: this.q,
        ingredient: this.ingredients
      };
      if (this.inPantry) {
        searchQuery.pantry = store.data.pantryItems;
      }
      store.setSearch(searchQuery);
      return searchQuery;
    },
    change() {
      this.$emit('change', this.buildSearch());
    },
    submit() {
      this.$emit('submit', this.buildSearch());
    },
    reset() {
      this.ingredients = null;
      this.inPantry = false;
      this.q = null;
      store.setSearch({});
      this.$emit('submit', this.buildSearch());
    }
  }
};
</script>


<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>
// Can't be scoped style due to multi-select overrides
<style>

.recipe-search h2{
  margin-left: 1rem;
  margin-bottom: 1rem;
}

.recipe-search{
  width: 100%;
}

.search-fields{
  display: flex;
  flex-direction: column;
}

.search-field{
  margin: 0 1rem;
  margin-bottom: 1rem;
}

.search-input{
  width: 100%;

  font-family: inherit;
}

.search-buttons{
  display:flex;
  justify-content: space-between;
}

.search-button{
  font-family: "Raleway", sans-serif;
  font-size: 0.75rem;
  padding: 0 1rem;
  cursor: pointer;
  width: 100%;

}

.search-button.submit{
  margin-right: 0.5rem;
}

.search-button.reset{
  margin-left: 0.5rem;
}

.recipe-search .checkbox-label{
  color: #9EA0A3;
  font-size: 1rem;
  user-select: none;
}

.recipe-search .in-pantry:focus{
  outline: none;
}

.recipe-search .in-pantry{

}

.recipe-search .basic{
  font-family: "Raleway", sans-serif;
  font-size: 1rem;

  border: 1px solid #a8a8a8;
  border-radius: 5px;
  padding: 0 0.5rem;
}

.multiselect__tags{
  font-family: "Raleway", sans-serif;

  border: 1px solid #a8a8a8;
}

.multiselect__single{
  padding-top: 0.25rem;
  font-size: 1rem;
  /*line-height: 1rem;*/
  color: #9EA0A3;
}

.multiselect__select{
  line-height: 1rem;
}

.multiselect__tag{
  font-family: "Raleway", sans-serif;
  background-color: rgb(92, 92, 92);
}

.multiselect__tag-icon::after{
  color: rgb(192, 192, 192);
}

.multiselect__tags-wrap{
  line-height: 1rem;
}
</style>
