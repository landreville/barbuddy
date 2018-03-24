<template>
    <div class="edit-ingredient">
    <v-text-field class="ingredient-input amount-input"
                  v-model="ingredient.amount"
                  type="number" label="Amount">
    </v-text-field>
    <v-select class="ingredient-input units-input"
              v-model="ingredient.unit" clearable
              :items="unitItems" label="Units">
    </v-select>
    <v-select class="ingredient-input name-input"
              v-model="ingredient.name"
              v-on:change="changed"
              v-on:input="changed"
              autocomplete clearable
              label="Ingredient" :items="ingredientItems">
    </v-select>
    </div>
</template>

<script>
export default {
  name: 'edit-ingredient',
  props: ['ingredient', 'ingredient-items', 'unit-items'],
  methods: {
    changed() {
      this.$emit('change');
    }
  }
};
</script>

<style scoped>
.edit-ingredient{
  display: flex;
}
.ingredient{
  padding: 0 1rem;
}
.ingredient-input{
  margin-right: 1rem;
}
.ingredient-input:last-child{
  margin-right: 0;
}

.name-input{
  flex-grow: 3;
}
</style>
