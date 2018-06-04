from datetime import datetime, timedelta
from decimal import Decimal
from pyramid.renderers import JSON
from sqlalchemy.orm.query import Query
from barbuddy.models import Base


json_renderer = JSON()


def includeme(config):
    config.add_renderer('json', json_renderer)


def json_adapter(adapt_type):
    def adapter(wrapped):
        json_renderer.add_adapter(adapt_type, wrapped)
        return wrapped
    return adapter


@json_adapter(datetime)
def adapt_datetime(dt, request):
    return dt.isoformat()


@json_adapter(Decimal)
def adapt_decimal(value, request):
    return float(value)


@json_adapter(Base)
def adapt_model(model_instance, request, exclude=(), include=()):
    return {name: getattr(model_instance, name)
            for name in include + tuple(c.name for c in model_instance.__table__.columns)
            if name not in exclude}


@json_adapter(Query)
def adapt_query(query, request):
    return query.all()


@json_adapter(timedelta)
def adapt_timedelta(value, request):
    return round(value.total_seconds(), 2)


def adapt_entities(entities):
    for entity, args in entities.items():
        adapt_entity(entity, *args)


def adapt_entity(entity, exclude=(), include=()):
    json_renderer.add_adapter(
        entity,
        lambda value, request: adapt_model(value, request, exclude, include)
    )


