<template>
    <header>
      <div class="header-title">
        <h1 class="title">
          <router-link :to="{ name: 'recipes' }">{{ title }}</router-link>
        </h1>
      </div>
      <div class="nav-container">
        <nav>
          <div class="nav-item"
               v-for="linkItem in breadcrumbs()"
               :linkItem="linkItem"
               :key="linkItem[0]">
            <router-link class="navlink"
                         :to="linkItem[1]">{{ linkItem[0] }}</router-link>

          </div>
        </nav>
      </div>
    </header>
</template>

<script>
export default {
  name: 'app-header',
  props: ['title'],
  methods: {
    breadcrumbs() {
      let links = [];
      let bc = this.$route.meta.breadcrumbs;
      if (!bc) {
        return [];
      }

      for (let i = 0; i < bc.length; i++) {
        let linkItem = bc[i];
        if ({}.toString.call(linkItem) === '[object Function]') {
          linkItem = linkItem(this.$route);
        }
        links.push(linkItem);
      }
      return links;
    }
  }
};
</script>

<style scoped>
header{
  width: 100%;
}

.header-title{
  margin: 0 auto;
  text-align: center;
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
  border-top: 3px double rgb(200, 200, 200);
  border-bottom: 3px double rgb(200, 200, 200);
}

nav{
  margin-left: 1rem;
  display: flex;
}

.nav-item{
  line-height: 1em;
  margin: 0.5rem 0;
}

.nav-item::after{
  content: "›";
  margin: 0.5rem 1rem;
}

.nav-item:last-child::after{
  content: "";
}

.navlink{
  color: rgb(68, 68, 68);
}
.navlink.active{
  /*text-decoration: underline;*/
}
</style>
