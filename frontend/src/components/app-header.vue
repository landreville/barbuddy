<template>
    <header>
      <div class="header-title">
        <h1 class="title">
          <router-link :to="{ name: 'recipes' }">{{ title }}</router-link>
        </h1>
      </div>
      <div class="nav-container">
        <nav>
          <div class="nav-item">
            <router-link class="navlink"
                         :class="{ active: ['recipes', 'recipe', 'edit-recipe'].indexOf($route.name) != -1}"
                         :to="{ name: 'recipes' }">Recipes</router-link>
          </div>
          <div class="nav-item">
            <router-link class="navlink"
                         :class="{ active: $route.name === 'pantry'}"
                         :to="{ name: 'pantry' }">Pantry</router-link>
          </div>
        </nav>
      </div>
    </header>
</template>

<script>
export default {
  name: 'app-header',
  props: ['title']
};
</script>

<style scoped>
header{
  width: 100%;
  margin-bottom: 1rem;
}

.header-title{
  margin: 0 auto;
  text-align: center;
  /*height: 6rem;*/
  color: rgb(68, 68, 68);
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


.nav-container{
  border-top: 3px double rgb(68, 68, 68);
  border-bottom: 3px double rgb(68, 68, 68);
}

nav{
  margin: 0 auto;
  max-width: 600px;
  display: flex;
}

.nav-item{
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
