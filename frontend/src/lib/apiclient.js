import axios from 'axios';
import { API_BASE_URL } from './constants';
import { sortIngredients } from './util';
import { store } from './store';

// const BASE_URL = 'http://localhost:4000/';
const BASE_URL = API_BASE_URL;
const API_URL = `${BASE_URL}api/`;


class AxiosProxy {

  constructor(baseURL) {
    this.axios = axios.create({ baseURL });
    this.jws = null;
  }

  get(url, query) {
    let getUrl = url;
    if (query) {
      let params = new URLSearchParams();
      for (let key in query) {
        if (query.hasOwnProperty(key)) {
          let value = query[key];
          if (Array.isArray(value)) {
            for (let i = 0; i < value.length; i++) {
              let arrayValue = value[i];
              if (arrayValue) {
                params.append(`${key}[]`, arrayValue);
              }
            }
          } else if (value) {
            params.append(key, value);
          }
        }
      }
      getUrl = `${getUrl}?${params.toString()}`;
    }
    return this.axios.get(getUrl, this.axiosConfig()).then(resp => resp.data.data);
  }

  post(url, body, refresh) {
    if (refresh === false) {
      return this.axios.post(url, body, this.axiosConfig());
    }
    return this.axios.post(url, body, this.axiosConfig());
  }

  put(url, body) {
    return this.axios.put(url, body, this.axiosConfig());
  }

  axiosConfig() {
    // Not using axios.create because the auth header value may change over time.
    return { headers: this.makeAuthHeader() };
  }

  makeAuthHeader() {
    if (store.data.accessToken) {
      return { Authorization: `Bearer ${store.data.accessToken}` };
    }
    return {};
  }
}


class ApiClientSingleton {
  constructor() {
    this.api = new AxiosProxy(API_URL);

    this.recipeBaseUrl = 'recipes';
    this.ingredientsUrl = 'ingredients';
    this.catalogsUrl = 'catalogs';
    this.categoriesUrl = 'categories';
    this.vesselsUrl = 'vessels';
  }

  getCatalogs() {
    return this.api.get(this.catalogsUrl);
  }

  getCategories() {
    return this.api.get(this.categoriesUrl);
  }

  getIngredients() {
    return this.api.get(this.ingredientsUrl);
  }

  getVessels() {
    return this.api.get(this.vesselsUrl);
  }

  getRecipe(id) {
    let url = `${this.recipeBaseUrl}/${id}`;
    return this.api.get(url).then((data) => {
      data.recipe_ingredients.sort(sortIngredients);
      return data;
    });
  }

  getRecipes(query) {
    return this.api.get(this.recipeBaseUrl, query).then((data) => {
      for (let i = 0; i < data.length; i++) {
        data[i].recipe_ingredients.sort(sortIngredients);
      }
      return data;
    });
  }

  putRecipe(id, recipe, image) {
    return this.api.put(`${this.recipeBaseUrl}/${id}`, recipe).then(
      (resp) => {
        if (image) {
          this.putRecipeImage(id, image);
        }
        return resp;
      }
    );
  }

  putRecipeImage(id, image) {
    let data = new FormData();
    data.append('image_file', image);
    return this.api.put(`${this.recipeBaseUrl}/${id}/image/main`, data);
  }

  recipeImageUrl(recipe) {
    if (recipe.image_url) {
      return `${BASE_URL}${recipe.image_url}`;
    }
    return `${API_URL}${this.recipeBaseUrl}/${recipe.recipe_name}/image/main`;
  }
}

export const ApiClient = new ApiClientSingleton();
