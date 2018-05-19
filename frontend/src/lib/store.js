
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
  addPantryItem(pantryItem) {
    this.data.pantryItems.push(pantryItem);
    this.data.pantryItems.sort();
    if (this.data.search.pantry && this.data.search.pantry.length > 0) {
      this.data.search.pantry = this.data.pantryItems;
    }
    this.save();
  },
  removePantryItem(pantryItem) {
    this.data.pantryItems.splice(this.data.pantryItems.indexOf(pantryItem), 1);
    if (this.data.search.pantry && this.data.search.pantry.length > 0) {
      this.data.search.pantry = this.data.pantryItems;
    }
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
        console.log('Restoring pantry', barbuddyStore.pantryItems);
        this.data.pantryItems = barbuddyStore.pantryItems;
      }
    }
  }
};
