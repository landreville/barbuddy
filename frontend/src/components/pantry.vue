<template>
    <div class="pantry list">

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
           v-for="ing in pantryItems" :key="ing.ingredientName" :ing="ing">
        <div class="list-item__title">
          {{ ing.ingredientName }}
        </div>
        <!-- TODO: Allow removing items -->
      </div>
    </div>
</template>

<script>
import { ApiClient } from '../lib/apiclient';

export default {
  name: 'pantry',
  created() {
    this.fetchIngredients();
  },
  data() {
    return {
      pantryItems: [
        { ingredientName: 'Angostura Bitters' },
        { ingredientName: 'Bourbon' },
        { ingredientName: 'Sweet Vermouth' }
      ],
      newPantryItem: null,
      ingredientOptions: []
    };
  },
  methods: {
    addIngredient() {
      for (let i = 0; i < this.pantryItems.length; i++) {
        if (this.pantryItems[i].ingredientName === this.newPantryItem) {
          this.newPantryItem = null;
          return;
        }
      }

      this.pantryItems.push({ ingredientName: this.newPantryItem });
      this.pantryItems.sort((a, b) =>
        (a.ingredientName < b.ingredientName
          ? -1 : (a.ingredientName > b.ingredientName) ? 1 : 0)
      );

      this.newPantryItem = null;
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
  padding: 0.5rem;

  border-bottom: 1px solid rgba(180, 180, 180, 0.5);
}

.list-item:last-child{
  border-bottom: none;
}

.list-item.controls{
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
}
</style>
