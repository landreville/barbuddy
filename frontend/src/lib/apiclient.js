import axios from 'axios';
import { JWS } from './jwt';
import { API_BASE_URL } from './constants';

// const BASE_URL = 'http://localhost:4000/';
const BASE_URL = API_BASE_URL;
const API_URL = `${BASE_URL}api/`;


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

  constructor(baseURL, apiClient) {
    this.axios = axios.create({ baseURL });
    this.apiClient = apiClient;
    this.jws = null;
    this.jwsFromStorage();
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

    return this.refresh().then(
      () => this.axios.get(getUrl, this.axiosConfig()).then(resp => resp.data.data)
    );
  }

  post(url, body, refresh) {
    if (refresh === false) {
      return this.axios.post(url, body, this.axiosConfig());
    }
    return this.refresh().then(() => this.axios.post(url, body, this.axiosConfig()));
  }

  put(url, body) {
    return this.refresh().then(() => this.axios.put(url, body, this.axiosConfig()));
  }

  axiosConfig() {
    // Not using axios.create because the auth header value may change over time.
    return { headers: this.makeAuthHeader() };
  }

  makeAuthHeader() {
    if (this.jws) {
      return { Authorization: `Bearer ${this.jws.accessToken}` };
    }
    return {};
  }

  refresh() {
    // Fake promise if refresh isn't necessary
    let maybePromise = Promise.resolve(true);

    this.jwsFromStorage();

    if (this.jws && !this.jws.isExpired() && this.jws.shouldRefresh()) {
      let refreshPromise = this.apiClient.refreshAuth(this.jws.accessToken);
      if (refreshPromise) {
        // Real promise this time
        maybePromise = refreshPromise;
      }
    }

    return maybePromise;
  }

  setAuthToken(token) {
    this.jws = new JWS(token);
    window.localStorage.setItem('jwt', token);
  }

  isLoggedIn() {
    this.jwsFromStorage();
    return this.jws && !this.jws.isExpired();
  }

  jwsFromStorage() {
    if (!this.jws) {
      let token = window.localStorage.getItem('jwt');
      if (token) {
        this.jws = new JWS(token);
      }
    }
  }
}


class ApiClientSingleton {
  constructor() {
    this.api = new AxiosProxy(API_URL, this);

    this.loginUrl = 'auth/login';
    this.refreshUrl = 'auth/refresh';
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
    return this.api.get(this.recipeBaseUrl, query);
  }

  isLoggedIn() {
    return this.api.isLoggedIn();
  }

  login(email, password) {
    return this.api.post(this.loginUrl, { email, password }).then((resp) => {
      let data = resp.data.data;
      if (data.success && data.token) {
        this.api.setAuthToken(data.token);
        return data.success;
      }
      return false;
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

  refreshAuth(token) {
    return this.api.post(this.refreshUrl, { token }, false).then(
      (resp) => {
        let data = resp.data.data;
        if (data.success && data.token) {
          this.api.setAuthToken(data.token);
          return data.success;
        }
        return false;
      }
    );
  }
}

export const ApiClient = new ApiClientSingleton();

