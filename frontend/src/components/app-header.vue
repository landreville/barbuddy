<template>
  <div class="header-top">
    <div class="header">
      <div class="header__title">
        <h1 class="title">
          <router-link :to="{ name: 'recipes' }">{{ title }}</router-link>
        </h1>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'app-header',
  props: ['title']
};
</script>

<style scoped>
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
