import axios from 'axios';

export default {

  baseUrl: 'http://localhost:4000/api/admin',
  recipesBaseUrl: 'http://localhost:4000/api/admin/recipes',
  recipeBaseUrl: 'http://localhost:4000/api/admin/recipe',
  ingredientsUrl: 'http://localhost:4000/api/admin/ingredients/',
  catalogsUrl: 'http://localhost:4000/api/admin/catalogs/',

  getCatalogs(callback) {
    axios.get(this.catalogsUrl).then(callback);
  },

  getIngredients(callback) {
    axios.get(this.ingredientsUrl).then(callback);
  },

  getRecipe(id, callback) {
    let url = `${this.recipeBaseUrl}/${id}`;
    axios.get(url).then(callback);
  },

  getRecipes(callback, view, search) {
    let url = this.recipesBaseUrl;
    if (view) {
      url = `${this.recipesBaseUrl}/${view}`;
    }

    let params = {};
    if (search) {
      for (let key of Object.keys(search)) {
        let value = search[key];
        params[key] = JSON.encode(value);
      }
    }

    axios.get(url).then(callback);
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
  }
};
