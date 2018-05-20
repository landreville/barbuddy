import Vue from 'vue';
import Router from 'vue-router';
import recipes from '@/components/recipes';
import recipe from '@/components/recipe';
import editrecipe from '@/components/editrecipe';
import login from '@/components/login';
import pantry from '@/components/pantry';
import { appTitle } from '@/lib/constants';

Vue.use(Router);

const router = new Router({
  routes: [
    {
      path: '/',
      name: 'recipes',
      component: recipes,
      meta: { title: appTitle, breadcrumbs: [['Recipes', { name: 'recipes' }]] }
    },
    {
      path: '/recipes/:id',
      name: 'recipe',
      component: recipe,
      props: { default: true },
      meta: {
        title: r => r.params.id,
        breadcrumbs: [
          ['Recipes', { name: 'recipes' }],
          r => [r.params.id, { name: 'recipe', id: r.params.id }]
        ]
      }
    },
    {
      path: '/recipes/:id/edit',
      name: 'edit-recipe',
      component: editrecipe,
      props: { default: true },
      meta: {
        title: r => r.params.id,
        breadcrumbs: [
          ['Recipes', { name: 'recipes' }],
          r => [r.params.id, { name: 'recipe', id: r.params.id }],
          r => [`Edit ${r.params.id}`, { name: 'edit-recipe', id: r.params.id }]
        ]
      }
    },
    {
      path: '/login',
      name: 'login',
      component: login,
      meta: { title: 'Login' }
    },
    {
      path: '/pantry',
      name: 'pantry',
      component: pantry,
      meta: { title: 'Pantry' }
    }
  ]
});


router.beforeEach((to, from, next) => {
  let title = to.meta.title;

  if ({}.toString.call(title) === '[object Function]') {
    title = title(to);
  }
  if (title !== appTitle) {
    title = `${appTitle} — ${title}`;
  }
  document.title = title;
  next();
});

export default router;
