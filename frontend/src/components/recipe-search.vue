<template>
  <div class="search">
    <div class="search-fields">
      <form>
      <div class="search-field">
        <input class="search-input basic" type="text" ref="searchInput"
               placeholder="Search..."
               v-model="searchQuery"
               @change="change"/>
      </div>
      <div class="search-field">
        <multiselect class="search-input ingredients"
                     v-model="ingredients"
                     :options="ingredientOptions"
                     :multiple="true"
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
      <div class="search-field">
        <button type="submit" class="search-button" @click.prevent="submit">
          Search
        </button>
      </div>
      </form>
    </div>
  </div>
</template>

<script>
import Multiselect from 'vue-multiselect';
import { ApiClient } from '../lib/apiclient';

export default {
  name: 'recipe-search',
  components: { Multiselect },
  created() {
    this.fetchIngredients();
  },
  mounted() {
    this.$refs.searchInput.focus();
  },
  data() {
    return {
      ingredientOptions: [],
      ingredients: null,
      inPantry: false,
      searchQuery: null
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
        q: this.searchQuery,
        ingredient: this.ingredients
      };
      if (this.inPantry) {
        let pantryItems = window.localStorage.getItem('pantry');
        if (pantryItems) {
          console.log(pantryItems);
          pantryItems = JSON.parse(pantryItems);
          searchQuery.pantry = pantryItems;

        }
      }

      return searchQuery;
    },
    change() {
      this.$emit('change', this.buildSearch());
    },
    submit() {
      this.$emit('submit', this.buildSearch());
    }
  }
};
</script>


<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>
<style>

.search{
  width: 100%;
}

.search-fields{
  max-width: 600px;
  margin: 1rem auto;

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
  font-size: 1rem;
}

.search-button{
  font-family: "Raleway", sans-serif;
  font-size: 1rem;
  cursor: pointer;
}

.checkbox-label{
  color: #9EA0A3;
  font-size: 1.5rem;
  user-select: none;
}

.in-pantry:focus{
  outline: none;
}

.in-pantry{

}

.basic{
  font-family: "Raleway", sans-serif;
  height: 3rem;
  font-size: 1.5rem;

  border: 1px solid #a8a8a8;
  border-radius: 5px;
  padding: 0 0.5rem;
}

.multiselect__tags{
  font-family: "Raleway", sans-serif;

  border: 1px solid #a8a8a8;
}

.multiselect__single{
  font-size: 1.5rem;
  line-height: 2rem;
  color: #9EA0A3;
}

.multiselect__select{
  line-height: 1.5rem;
}

.multiselect__tag{
  font-family: "Raleway", sans-serif;
  font-size: 1.5rem;
}
</style>
