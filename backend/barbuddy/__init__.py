from pyramid.config import Configurator


def main(global_config, **settings):
    config = Configurator(settings=settings)
    config.include('cornice')
    config.include('barbuddy.models')
    config.scan('barbuddy.views')
    config.add_static_view('images', 'static/images')
    config.include('barbuddy.renderers')

    return config.make_wsgi_app()
