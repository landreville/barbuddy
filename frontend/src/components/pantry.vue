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
          <!-- TODO: Allow removing items -->
        </div>
      </div>
    </div>
</template>

<script>
import { ApiClient } from '../lib/apiclient';

export default {
  name: 'pantry',
  created() {
    this.fetchIngredients();
    this.fetchPantry();
  },
  data() {
    return {
      pantryItems: [],
      newPantryItem: null,
      ingredientOptions: []
    };
  },
  methods: {
    addIngredient() {
      for (let i = 0; i < this.pantryItems.length; i++) {
        if (this.pantryItems[i] === this.newPantryItem) {
          this.newPantryItem = null;
          return;
        }
      }
      if (this.newPantryItem) {
        this.pantryItems.push(this.newPantryItem);
        this.pantryItems.sort();
        this.savePantry();
      }
      this.newPantryItem = null;
    },
    savePantry() {
      console.log(this.pantryItems);
      window.localStorage.setItem('pantry', JSON.stringify(this.pantryItems));
    },
    fetchPantry() {
      let pantryItems = window.localStorage.getItem('pantry');
      if (pantryItems) {
        this.pantryItems = JSON.parse(pantryItems);
      }
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

  border-bottom: 1px solid rgba(180, 180, 180, 0.5);
}


.list-item.controls{
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
}

h2{
  margin-left: 1rem;
}



.ingredient-select{

}

button{
  font-family: "Raleway", sans-serif;
  font-size: 0.75rem;
  padding: 0 0.25rem;
  cursor: pointer;
  width: 100%;
  margin-left: 0.5rem;
}
</style>
