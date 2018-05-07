import axios from 'axios';

const BASE_URL = 'http://localhost:4000/api/';
const AUTH_TOKEN_NAME = 'jwt';


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


class AxiosProxy {

  constructor(baseURL) {
    this.axios = axios.create({ baseURL });
  }

  get(url) {
    return this.axios.get(url, this.axiosConfig()).then(resp => resp.data.data);
  }

  post(url, body) {
    return this.axios.post(url, body);
  }

  put(url, body) {
    return this.axios.put(url, body);
  }

  axiosConfig() {
    // Not using axios.create because the auth header value may change over time.
    return { headers: this.makeAuthHeader() };
  }

  makeAuthHeader() {
    let localStorage = window.localStorage;
    let token = localStorage.getItem(AUTH_TOKEN_NAME);
    if (token) {
      return { Authorization: `Bearer ${token}` };
    }
    return {};
  }

  setAuthToken(token) {
    let localStorage = window.localStorage;
    localStorage.setItem(AUTH_TOKEN_NAME, token);
  }
}


export default {
  api: new AxiosProxy(BASE_URL),
  loginUrl: 'login',
  recipeBaseUrl: 'recipes',
  ingredientsUrl: 'ingredients',
  catalogsUrl: 'catalogs',
  categoriesUrl: 'categories',
  vesselsUrl: 'vessels',

  getCatalogs() {
    return this.api.get(this.catalogsUrl);
  },

  getCategories() {
    return this.api.get(this.categoriesUrl);
  },

  getIngredients() {
    return this.api.get(this.ingredientsUrl);
  },

  getVessels() {
    return this.api.get(this.vesselsUrl);
  },

  getRecipe(id) {
    let url = `${this.recipeBaseUrl}/${id}`;
    return this.api.get(url).then((data) => {
      data.recipe_ingredients.sort(sortIngredients);
      return data;
    });
  },

  getRecipes(callback, view) {
    let url = this.recipeBaseUrl;
    if (view) {
      url = `${this.recipeBaseUrl}/${view}`;
    }

    return this.api.get(url);
  },

  isLoggedIn() {
    let token = window.localStorage.getItem(AUTH_TOKEN_NAME);
    // TODO: decode token and verify ttl
  },

  login(email, password) {
    return this.api.post(this.loginUrl, { email, password }).then((resp) => {
      let data = resp.data.data;
      if (data.success && data.token) {
        this.api.setAuthToken(data.token);
        return data.success;
      }
      return false;
    });
  },

  putRecipe(id, recipe, image) {
    return this.api.put(`${this.recipeBaseUrl}/${id}`, recipe).then(
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
    return this.api.put(`${this.recipeBaseUrl}/${id}/image/main`, data);
  },

  recipeImageUrl(recipe) {
    return `${BASE_URL}${this.recipeBaseUrl}/${recipe.recipe_name}/image/main`;
  }
};
