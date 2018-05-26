
export const store = {
  data: {
    recipes: [],
    search: {},
    pantryItems: []
  },
  setRecipes(recipes) {
    this.data.recipes = recipes;
    this.save();
  },
  setSearch(search) {
    this.data.search = search;
    this.save();
  },
  save() {
    let saveData = {
      search: this.data.search,
      pantryItems: this.data.pantryItems
    };
    window.localStorage.setItem('barbuddy-store', JSON.stringify(saveData));
  },
  load() {
    let barbuddyStore = window.localStorage.getItem('barbuddy-store');
    if (barbuddyStore) {
      barbuddyStore = JSON.parse(barbuddyStore);

      if (barbuddyStore.search) {
        this.data.search = barbuddyStore.search;
      }
      if (barbuddyStore.pantryItems) {
        this.data.pantryItems = barbuddyStore.pantryItems;
      }
    }
  }
};
