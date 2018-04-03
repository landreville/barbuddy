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
    get "/admin/catalogs", AdminCatalogController, :catalogs
    get "/admin/catalogs/:catalog/recipes", AdminCatalogController, :catalogs_recipes
    get "/recipes", RecipeController, :index
    get "/recipes/:id", RecipeController, :get
    post "/recipes", RecipeController, :add
    put "/recipes/:id", RecipeController, :update
#    get "/admin/recipes/:view", AdminRecipeController, :recipes_view
#    get "/admin/recipe/:id", AdminRecipeController, :recipe
#    put "/admin/recipe/:id", AdminRecipeController, :update
#    get "/admin/recipe/:id/image/:filename", AdminRecipeController, :get_image
#    put "/admin/recipe/:id/image", AdminRecipeController, :update_image
    get "/admin/ingredients", AdminIngredientController, :ingredients
    get "/admin/ingredients/:view", AdminIngredientController, :ingredients_view
  end
end
