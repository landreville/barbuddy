defmodule BarchefWeb.Router do
  use BarchefWeb, :router
  require Plug.Logger

  pipeline :require_auth do
    # TODO: Don't use Plug, write authentication checker using decode_and_verify

  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Plug.Logger, log: :debug
  end

  scope "/api", BarchefWeb do
    pipe_through [:api]
    post "/login", AuthController, :login
    get "/catalogs", CatalogController, :index
    get "/categories", CategoryController, :index
    get "/vessels", VesselController, :index
    get "/recipes", RecipeController, :index
    get "/recipes/:id", RecipeController, :get
    get "/recipes/:recipe_name/image/:image_type", RecipeImageController, :get
    get "/ingredients", IngredientController, :ingredients
    get "/ingredients/:view", IngredientController, :ingredients_view
  end

  scope "/api", BarchefWeb do
    pipe_through [:api, :require_auth]
    post "/recipes", RecipeController, :add
    put "/recipes/:recipe_name/image/:image_type", RecipeImageController, :update
    put "/recipes/:id", RecipeController, :update
  end

end

