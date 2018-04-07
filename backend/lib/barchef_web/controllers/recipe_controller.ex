defmodule BarchefWeb.RecipeController do
  use BarchefWeb, :controller
  alias BarchefDB.Recipe
  alias BarchefDB.RecipeIngredient
  alias Barchef.Repo
  import Ecto.Query

  def index(conn, _params) do
    query = from r in Recipe,
      join: ri in RecipeIngredient, on: r.recipe_name == ri.recipe_name,
      select: r,
      preload: [recipe_ingredients: ri]
    recipes = Repo.all(query)
    Logger.info "#{inspect recipes}"
    json conn, %{"data" => recipes}
  end

  def get(conn, %{"id" => id}) do
    query = from r in Recipe,
      where: r.recipe_name == ^id,
      select: r

    json conn, %{"data" => Repo.one(query)}
  end

  def add(conn, params) do
    changeset_render(conn, Recipe.changeset(%Recipe{}, params), &Repo.insert/1)
  end

  def update(conn, params) do
    recipe = Repo.get(Recipe, params["id"])
    changeset_render(conn, Recipe.changeset(recipe, params), &Repo.update/1)
  end
end
