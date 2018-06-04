"""
All models are automapped from the database.

Access models by using the CamelCase version of their table name. For example
recipe_ingredient is accessed at barbuddy.models.RecipeIngredient.
"""
import re
import sys

import inflect
from sqlalchemy import engine_from_config
from sqlalchemy.ext.automap import automap_base, generate_relationship
from sqlalchemy.orm import scoped_session, sessionmaker, backref
from sqlalchemy.orm.interfaces import MANYTOMANY
from zope.sqlalchemy import ZopeTransactionExtension

__all__ = ['includeme']

DBSession = scoped_session(sessionmaker(extension=ZopeTransactionExtension()))

Base = automap_base()

_pluralizer = inflect.engine()


def camelize_classname(base, tablename, table):
    """
    Return a CamelCase model name for the table name.

    Eg my_table -> MyTable
    """

    return str(
        tablename[0].upper() +
        re.sub(r'_([a-z])', lambda m: m.group(1).upper(), tablename[1:])
    )


override_rels = {
    'fav_recipe_user_id_fkey': 'fav_recipes',
    'fav_recipe_recipe_name_fkey': 'fav_appusers',
    'fav_ingredient_user_id_fkey': 'fav_ingredients',
}


def name_for_collection_relationship(base, local_cls, referred_cls, constraint):
    """
    Return underscore_case pluralized name.
    Eg MyThing -> my_things
    """
    if constraint.name in override_rels:
        return override_rels[constraint.name]

    referred_name = referred_cls.__name__
    pluralized_name = pluralize(referred_name)
    return pluralized_name


def pluralize(word):
    uncamelized = re.sub(
        r'[A-Z]', lambda m: '_{}'.format(m.group(0).lower()), word
    )[1:]
    return _pluralizer.plural(uncamelized)


def name_for_scalar_relationship(base, local_cls, referred_cls, constraint):
    name = referred_cls.__name__.lower()
    local_table = local_cls.__table__
    if name in local_table.columns:
        new_name = name + "_rel"
        return new_name
    return name


def includeme(config):
    engine = engine_from_config(config.get_settings(), 'sqlalchemy.')
    DBSession.configure(bind=engine)
    Base.prepare(
        engine,
        reflect=True,
        classname_for_table=camelize_classname,
        name_for_collection_relationship=name_for_collection_relationship,
        name_for_scalar_relationship=name_for_scalar_relationship,
    )

    for cls in Base.classes:
        setattr(sys.modules[__name__], cls.__name__, cls)
        __all__.append(cls.__name__)

    config.add_request_method(
        lambda req: DBSession, name='db', property=True, reify=True
    )
