<template>
  <div class="header-top">
    <header>
      <div class="header__title">
        <h1 class="title">
          <router-link :to="{ name: 'recipes' }">{{ title }}</router-link>
        </h1>
      </div>
    </header>
    <div class="navcontainer">
      <nav>
        <div class="navitem">
          <router-link class="navlink"
                       :class="{ active: ['recipes', 'recipe', 'edit-recipe'].indexOf($route.name) != -1}"
                       :to="{ name: 'recipes' }">Recipes</router-link>
        </div>
        <div class="navitem">
          <router-link class="navlink"
                       :class="{ active: $route.name === 'pantry'}"
                       :to="{ name: 'pantry' }">Pantry</router-link>
        </div>
      </nav>
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
  margin-bottom: 1rem;
}

header{
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


.navcontainer{
  border-top: 3px double rgb(68, 68, 68);
  border-bottom: 3px double rgb(68, 68, 68);
}

nav{
  margin: 0 auto;
  max-width: 600px;
  display: flex;


}

.navitem{
  line-height: 1em;
  margin: 0.5rem 1rem;
}

.navlink{
  color: rgb(68, 68, 68);
}
.navlink.active{
  text-decoration: underline;
}
</style>
