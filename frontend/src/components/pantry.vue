<template>
    <div class="pantry">
      <h2>Pantry Items</h2>
      <div class="list">
        <div class="list-item controls">
          <div class="ingredient-select">
            <select v-model="newPantryItem">
              <option :value="null">-- Add Pantry Item --</option>
              <option v-for="opt in ingredientOptions" :key="opt" :opt="opt">
                {{ opt }}
              </option>
            </select>
          </div>
          <div class="add-btn">
            <button @click="addIngredient">Add</button>
          </div>
        </div>

        <div class="list-item"
             v-for="ing in pantryItems" :key="ing" :ing="ing">
          <div class="list-item__title">
            {{ ing }}
          </div>
          <div class="remove-btn">
            <button @click="removeIngredient(ing)">X</button>
          </div>

        </div>
      </div>
    </div>
</template>

<script>
import { ApiClient } from '../lib/apiclient';
import { store } from '../lib/store';

export default {
  name: 'pantry',
  created() {
    this.fetchIngredients();
  },
  data() {
    return {
      pantryItems: store.data.pantryItems,
      newPantryItem: null,
      ingredientOptions: []
    };
  },
  methods: {
    addIngredient() {
      for (let i = 0; i < store.data.pantryItems.length; i++) {
        if (store.data.pantryItems[i] === this.newPantryItem) {
          this.newPantryItem = null;
          return;
        }
      }
      if (this.newPantryItem) {
        store.addPantryItem(this.newPantryItem);
      }
      this.newPantryItem = null;

      this.$emit('changed', store.data.pantryItems);
    },
    removeIngredient(pantryItem) {
      store.removePantryItem(pantryItem);
      this.$emit('changed', store.data.pantryItems);
    },
    fetchIngredients() {
      ApiClient.getIngredients().then(
        (data) => {
          this.ingredientOptions = data;
        }
      );
    }
  }
};
</script>

<style scoped>
.list{
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.list-item{
  background-color: #FFFFFF;
  width: 100%;
  max-width: 800px;
  padding: 0.5rem 1rem;
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid rgba(180, 180, 180, 0.5);
}

h2{
  margin: 0 0 0.5rem 1rem;
}

.add-btn > button{
  font-family: "Raleway", sans-serif;
  font-size: 0.75rem;
  padding: 0 0.25rem;
  cursor: pointer;
  width: 100%;
  margin-left: 0.5rem;
}

.remove-btn > button{
  font-family: "Raleway", sans-serif;
  font-size: 0.5rem;
  padding: 0 0rem;
  cursor: pointer;
  width: 100%;
  margin-left: 0.5rem;
}
</style>
