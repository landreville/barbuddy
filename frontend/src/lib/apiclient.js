import axios from 'axios';

export const baseUrl = 'http://localhost:4000/api';

function sortIngredients(a, b) {
  if (a.unit === 'ounce' && b.unit !== 'ounce') {
    return -1;
  } else if (b.unit === 'ounce' && a.unit !== 'ounce') {
    return 1;
  }

  if (a.unit !== b.unit) {
    if (a.unit === null) {
      return 1;
    } else if (b.unit === null) {
      return -1;
    }
    let x = a.unit.toLowerCase();
    let y = b.unit.toLowerCase();
    if (x < y) {
      return -1;
    } else if (x > y) {
      return 1;
    }
  }

  if (b.amount === a.amount) {
    let x = a.ingredient_name.toLowerCase();
    let y = b.ingredient_name.toLowerCase();
    if (x < y) {
      return -1;
    } else if (x > y) {
      return 1;
    }
  }

  return b.amount - a.amount;
}

export default {
  recipeBaseUrl: `${baseUrl}/recipes`,
  ingredientsUrl: `${baseUrl}/ingredients`,
  catalogsUrl: `${baseUrl}/catalogs`,
  categoriesUrl: `${baseUrl}/categories`,
  vesselsUrl: `${baseUrl}/vessels`,

  getCatalogs() {
    return axios.get(this.catalogsUrl).then(resp => resp.data.data);
  },

  getCategories() {
    return axios.get(this.categoriesUrl).then(resp => resp.data.data);
  },

  getIngredients() {
    return axios.get(this.ingredientsUrl).then(resp => resp.data.data);
  },

  getVessels() {
    return axios.get(this.vesselsUrl).then(resp => resp.data.data);
  },

  getRecipe(id) {
    let url = `${this.recipeBaseUrl}/${id}`;
    return axios.get(url).then((resp) => {
      let recipe = resp.data.data;
      recipe.recipe_ingredients.sort(sortIngredients);
      return recipe;
    });
  },

  getRecipes(callback, view) {
    let url = this.recipeBaseUrl;
    if (view) {
      url = `${this.recipeBaseUrl}/${view}`;
    }

    return axios.get(url).then(resp => resp.data.data);
  },

  putRecipe(id, recipe, image) {
    return axios.put(`${this.recipeBaseUrl}/${id}`, recipe).then(
      (resp) => {
        if (image) {
          this.putRecipeImage(id, image);
        }
        return resp;
      }
    );
  },

  putRecipeImage(id, image) {
    let data = new FormData();
    data.append('image_file', image);
    return axios.put(`${this.recipeBaseUrl}/${id}/image/main`, data);
  },

  recipeImageUrl(recipe) {
    return `${baseUrl}/recipes/${recipe.recipe_name}/image/main`;
  }
};
