<template>
  <div class="edit-ingredient">

    <div class="field field__amount">
      <input class="amount"
             type="text"
             placeholder="Amount"
             v-model.number="ingredient.amount"/>
    </div>

    <div class="field field__unit">
      <select class="unit"
                v-model="ingredient.unit">
        <option value="">-- Choose Unit --</option>
        <option v-for="unit in unitOptions"
                :unit="unit"
                :key="unit.text"
                :value="unit.value">
          {{ unit.text }}
        </option>
      </select>
    </div>

    <div class="field field__name">
      <select class="name"
              v-model="ingredient.ingredient_name"
              v-on:change="changed">
        <option value="">-- Choose Ingredient --</option>
        <option
          v-for="ingredient in ingredientOptions"
          :ingredient="ingredient"
          :key="ingredient"
          :value="ingredient">
          {{ ingredient }}
        </option>
      </select>
    </div>


    <div class="field field__optional flag">
      <input :id="'optional' + ingredient.ingredient_name"
             type="checkbox"
             v-model="ingredient.optional"/>
      <label :for="'optional' + ingredient.ingredient_name">Optional</label>
    </div>

    <div class="field field__garnish flag">
      <input :id="'garnish' + ingredient.ingredient_name"
             type="checkbox"
             v-model="ingredient.garnish"/>
      <label :for="'garnish' + ingredient.ingredient_name">Garnish</label>
    </div>

  </div>
</template>

<script>
export default {
  name: 'edit-ingredient',
  props: ['ingredient', 'ingredient-options', 'unit-options'],
  methods: {
    changed() {
      this.$emit('change');
    }
  }
};
</script>

<style scoped>
.edit-ingredient{
  width: 100%;
  display: flex;
}
.field{
  margin-right: 1rem;
  flex: 1;
}
input[type="text"], select{
  min-width: 0;
  width: 100%;
}
.edit-ingredient > *:last-child{
  margin-right: 0;
}

.field__unit{
  flex: 2;
}

.field__name{
  flex: 3;
}

.flag{
  display: flex;
  flex-wrap: nowrap;
}

.flag > input{
  margin-right: 0.25rem;
}
</style>
