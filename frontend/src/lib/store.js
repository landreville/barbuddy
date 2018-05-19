

export const store = {
  data: {
    recipes: [],
    search: {}
  },
  setRecipes(recipes) {
    this.data.recipes = recipes;
  },
  setSearch(search) {
    this.data.search = search;
  }
};
