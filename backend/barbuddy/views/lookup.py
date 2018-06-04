import sys
from cornice import Service
from sqlalchemy.sql.expression import ClauseElement
from barbuddy import models


_entities = {
    'catalogs': models.Catalog.catalog,
    'ingredients': models.Ingredient.ingredient_name,
    'vessels': models.Vessel.vessel
}


def _make_lookup_get(entity: str, expr: ClauseElement):
    """
    Set module-level attributes for a Cornice service and GET function for the given
    entity.

    For example take the following code:
    > _make_lookup_get('my_entity', MyModel.my_column)

    This will make two module attributes on this module:
    * my_entity_svc --- A Cornice service hosted on /my_entity
    * my_entity_get --- A function for querying the given SQLAlchemy expression. This
        is decorated by the service and will be found by a Venusian scan.
    """
    svc = Service(name=entity, path='/api/{}'.format(entity), renderer='json')

    @svc.get()
    def lookup_get(request):
        query = request.db.query(expr).order_by(expr)
        return {'data': [row[0] for row in query]}

    fn_name = '{}_get'.format(entity)
    lookup_get.__name__ = fn_name
    setattr(sys.modules[__name__], '{}_svc'.format(entity), svc)
    setattr(sys.modules[__name__], fn_name, lookup_get)


# This could probably be done in a more OOP fashion with a few classes,
# but this is just so damn fun.
# Using underscore prefixes because only the attributes set by _make_lookup_get
# are exported.
for _entity, _expr in _entities.items():
    _make_lookup_get(_entity, _expr)
