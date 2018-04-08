import axios from 'axios';

export const baseUrl = 'http://localhost:4000/api';

export default {
  recipeBaseUrl: `${baseUrl}/recipes`,
  ingredientsUrl: `${baseUrl}/ingredients`,
  catalogsUrl: `${baseUrl}/catalogs`,

  getCatalogs(callback) {
    axios.get(this.catalogsUrl).then(callback);
  },

  getIngredients(callback) {
    axios.get(this.ingredientsUrl).then(callback);
  },

  getRecipe(id) {
    let url = `${this.recipeBaseUrl}/${id}`;
    return axios.get(url);
  },

  getRecipes(callback, view) {
    let url = this.recipeBaseUrl;
    if (view) {
      url = `${this.recipeBaseUrl}/${view}`;
    }

    return axios.get(url);
  },

  putRecipe(recipe, image, callback) {
    axios.put(`${this.recipeBaseUrl}/${recipe._id}`, recipe).then(
      (resp) => {
        if (image) {
          this.putRecipeImage(recipe._id, image);
        }
        return resp;
      }
    ).then(callback);
  },

  putRecipeImage(id, image) {
    let data = new FormData();
    data.append('image', image);
    return axios.put(`${this.recipeBaseUrl}/${id}/image`, data);
  },

  recipeImageUrl(recipe) {
    return `${baseUrl}/recipes/${recipe.recipe_name}/image/main`;
  }
};
