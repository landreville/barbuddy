<template>
  <div class="app">
    <div class="header-top">
      <div class="header">
        <div class="header__title">
          <h1 class="title">
            <router-link :to="{ name: 'recipes' }">{{ title }}</router-link>
          </h1>
        </div>
      </div>
    </div>
    <router-view></router-view>
  </div>
</template>

<script>
import { appTitle } from '@/lib/constants';
import header from './components/header';

export default {
  name: 'barchef-app',
  components: { 'app-header': header },
  data() {
    return {
      title: appTitle
    };
  }
};
</script>

<style>
@import 'assets/css/bundle.css';

.header-top{
  width: 100%;
  border-bottom: 3px double black;
  margin-bottom: 1rem;
}

.header{
  margin: 0 auto;
  text-align: center;
  /*height: 6rem;*/
  color: rgb(68, 68, 68);

  max-width: 1000px;
}

.title{
  font-family: "Josefin Sans", sans-serif;
  font-weight: bold;
  font-size: 4rem;
  line-height: 4rem;

  margin: 0;
  padding: 1rem 0
}

.title a{
  color: inherit;
  text-decoration: none;
  outline: none;
}
</style>
