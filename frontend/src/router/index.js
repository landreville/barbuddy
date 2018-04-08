import Vue from 'vue';
import Router from 'vue-router';
import recipes from '@/components/recipes';
import recipe from '@/components/recipe';
import editrecipe from '@/components/editrecipe';

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
    },
    {
      path: '/recipes/:id/edit',
      name: 'edit-recipe',
      component: editrecipe,
      props: { default: true }
    }
  ],
});
