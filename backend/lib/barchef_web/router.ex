defmodule BarchefWeb.Router do
  use BarchefWeb, :router
  require Plug.Logger

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
    pipe_through :api
    get "/catalogs", CatalogController, :catalogs
    get "/recipes", RecipeController, :index
    get "/recipes/:id", RecipeController, :get
    get "/recipes/:recipe_name/image/:image_type", RecipeImageController, :get
    put "/recipes/:recipe_name/image/:image_type", RecipeImageController, :update
    post "/recipes", RecipeController, :add
    put "/recipes/:id", RecipeController, :update
    get "/ingredients", IngredientController, :ingredients
    get "/ingredients/:view", IngredientController, :ingredients_view
  end
end
