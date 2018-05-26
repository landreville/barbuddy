<template>
    <div class="pantry">
      <h2 class="pantry__title">Pantry Items</h2>
      <div class="pantry__list">
        <div class="pantry__list-item controls">
          <multiselect class="pantry__select"
                       v-model="pantryItems"
                       :options="ingredientOptions"
                       :multiple="true"
                       :searchable="true"
                       :close-on-select="false"
                       deselectLabel=""
                       selectLabel=""
                       placeholder="Pantry Items..."
                       @input="change">
          </multiselect>
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
      ingredientOptions: []
    };
  },
  methods: {
    change() {
      store.data.pantryItems = this.pantryItems;
      this.$emit('changed', store.data.pantryItems);
      store.save();
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

// Not scoped so it will target the multiselect widget inner pieces
<style>
.pantry__list{
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.pantry__list-item{
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

.pantry__title{
  margin: 0 0 0.5rem 1rem;
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

.multiselect__content-wrapper{
  box-shadow: 0px 2px 4px 0px rgba(0, 0, 0, 0.5);
}
</style>
