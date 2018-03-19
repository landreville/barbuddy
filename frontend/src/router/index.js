import Vue from 'vue';
import Router from 'vue-router';
import recipes from '@/components/recipes';
import recipe from '@/components/recipe';

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: '/',
      name: 'recipes',
      component: recipes,
    },
    {
      path: '/recipes/:id',
      name: 'recipe',
      component: recipe,
      props: { default: true }
    }
  ],
});
