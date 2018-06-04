from cornice import Service
from cornice.resource import resource
from sqlalchemy.orm import joinedload, aliased, contains_eager
from sqlalchemy import and_, or_, func, distinct
from pyramid.response import Response
from pyramid.httpexceptions import HTTPFound
from barbuddy import models as m
from barbuddy.renderers import adapt_entities
from barbuddy.constants import vessel_images


adapt_entities({
    m.Recipe: [('active', 'inserted_at', 'user_id', 'photo_path'),
               ('recipe_ingredients',)],
    m.RecipeIngredient: [('recipe_name',)],
})


@resource(
    collection_path='/api/recipes',
    path='/api/recipes/{recipe_name}',
    renderer='json'
)
class Recipe(object):

    def __init__(self, request, context=None):
        self.request = request
        self.db = request.db
        params = {}
        params.update(request.params.mixed())
        params.update(self.request.matchdict)
        self.params = params

    def collection_get(self):
        recipes = self.db.query(m.Recipe).join(m.RecipeIngredient).options(
            contains_eager(m.Recipe.recipe_ingredients)
        ).order_by(m.Recipe.recipe_name)
        if self.params:
            recipes = self._search_recipes(recipes)

        return {'data': recipes}

    def get(self):
        recipe = self.db.query(m.Recipe).options(
            joinedload(m.Recipe.recipe_ingredients)
        ).get(self.params['recipe_name'])
        return {'data': recipe}

    def _search_recipes(self, query):
        if self.params.get('q'):
            query = self._apply_basic_query(query)
        if self.params.get('ingredients[]'):
            query = self._apply_ingredients_query(query)
        if self.params.get('pantry[]'):
            query = self._apply_pantry_query(query)
        return query

    def _apply_basic_query(self, query):
        q = '%{}%'.format(self.params['q'])
        return query.filter(m.Recipe.recipe_name.ilike(q))

    def _apply_ingredients_query(self, query):
        ing_names = self.params['ingredient[]']
        child_ing = aliased(m.Ingredient)

        riq = (
            self.db.query(m.RecipeIngredient)
            .join(m.Ingredient,
                  m.RecipeIngredient.ingredient_name == m.Ingredient.ingredient_name)
            .outerjoin(m.Substitute)
            .outerjoin(child_ing,
                  m.Ingredient.ingredient_name == child_ing.parent_ingredient_name)
            .filter(or_(
                m.Ingredient.ingredient_name.in_(ing_names),
                child_ing.ingredient_name.in_(ing_names),
                m.Substitute.ingredient_name.in_(ing_names)
            ))
            .group_by(m.RecipeIngredient.recipe_name)
            .having(
                func.count(distinct(m.RecipeIngredient.ingredient_name)) == len(ing_names)
            )
        ).subquery()

        return query.join(riq, m.RecipeIngredient.recipe_name == riq.recipe_name)

    def _apply_pantry_query(self, query):
        pantry_items = self.params['pantry[]']

        sibling_ing = aliased(m.Ingredient)
        count_ing = func.count(distinct(m.RecipeIngredient.ingredient_name))
        subq = (
            self.db.query(
                m.RecipeIngredient.recipe_name,
                count_ing.label('ingredient_count'),
                count_ing.filter(or_(
                    m.RecipeIngredient.ingredient_name.in_(pantry_items),
                    m.Ingredient.parent_ingredient_name.in_(pantry_items),
                    sibling_ing.ingredient_name.in_(pantry_items),
                    m.Substitute.ingredient_name.in_(pantry_items)
                )).label('ingredient_matches')
            )
            .select_from(m.RecipeIngredient)
            .join(m.Ingredient,
                  m.RecipeIngredient.ingredient_name == m.Ingredient.ingredient_name)
            .outerjoin(m.Substitute,
                       m.Ingredient.ingredient_name == m.Substitute.ingredient_name)
            .outerjoin(
                sibling_ing,
                sibling_ing.parent_ingredient_name == m.Ingredient.parent_ingredient_name
            )
            .filter(
                m.RecipeIngredient.optional == False,
                m.RecipeIngredient.garnish == False
            )
            .group_by(m.RecipeIngredient.recipe_name)
        ).subquery()

        riq = (
            self.db.query(subq)
            .filter((subq.c.ingredient_count - subq.c.ingredient_matches) <= 2)
        ).subquery()

        query = (
            query.join(riq, riq.c.recipe_name == m.RecipeIngredient.recipe_name)
            .order_by(
                riq.c.ingredient_count - riq.c.ingredient_matches,
                m.RecipeIngredient.recipe_name
            )
        )
        return query


image_svc = Service('image', '/api/recipes/{recipe_name}/image/{image_type}')


@image_svc.get()
def recipe_image(request):
    recipe_name = request.matchdict['recipe_name']
    ri = request.db.query(m.RecipeImage).filter_by(
        recipe_name=recipe_name,
        image_type=request.matchdict['image_type']
    ).one_or_none()

    if ri:
        return Response(
            ri.image,
            content_type=ri.mime_type
        )

    vessel = request.db.query(m.Recipe.vessel).filter_by(recipe_name=recipe_name).scalar()
    image_url = vessel_images.get(vessel, '/images/vessel/coupe.png')
    return HTTPFound(image_url)
