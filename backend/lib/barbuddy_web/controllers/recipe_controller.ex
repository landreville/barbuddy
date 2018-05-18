defmodule BarBuddyWeb.RecipeController do
  use BarBuddyWeb, :controller
  alias BarBuddyDB.Recipe
  alias BarBuddyDB.RecipeIngredient
  alias BarBuddy.Repo
  import Ecto.Query

  def index(conn, params) do
    query = from r in Recipe,
                 join: ri in assoc(r, :recipe_ingredients),
                 on: r.recipe_name == ri.recipe_name,
                 select: r,
                 preload: [
                   recipe_ingredients: ri
                 ]

    query = case params do
      %{"q" => q} -> basic_query(query, q)
      _ -> query
    end

    query = case params do
      %{"ingredient" => ings} -> query_ingredients(query, ings)
      _ -> query
    end

    recipes = Repo.all(query)
    render conn, "recipes.json", recipes: recipes
  end

  def get(conn, %{"id" => id}) do
    query = from r in Recipe,
                 join: ri in assoc(r, :recipe_ingredients),
                 where: r.recipe_name == ^id,
                 select: r,
                 preload: [recipe_ingredients: ri]

    render conn, "data.json", data: Repo.one(query)
  end

  def add(conn, %{"recipes" => recipes}) do
    recipes
    |> Enum.map(&(add(conn, &1)))
    render conn, "success.json", success: true
  end

  def add(conn, params) do
    changeset_render(conn, Recipe.changeset(%Recipe{}, params), &Repo.insert/1)
    render conn, "success.json", success: true
  end

  def update(conn, params) do
    recipe = Repo.get(Recipe, params["id"])
    changeset_render(conn, Recipe.changeset(recipe, params), &Repo.update/1)
    json conn, %{"data" => %{"success" => true}}
  end

  defp exact_query(query, field_atom, params) do
    field_str = Atom.to_string(field_atom)
    case params do
      %{^field_str => value} ->
        where(query, [ri], field(ri, ^field_atom) == ^value)
      _ -> query
    end
  end

  defp basic_query(query, q) do
    like_q = "%#{q}%"
    where(query, [r], ilike(r.recipe_name, ^like_q))
  end

  defp query_ingredients(query, ings) do
    ing_names = if is_list(ings) do
      ings
    else
      [ings]
    end

    riq = Enum.reduce(
      ing_names,
      from(ri in RecipeIngredient),
      &(where(&2, [ri], ri.ingredient_name == ^&1))
    )
    
    riq
    |> select([ri], ri.recipe_name)
    |> group_by([ri], ri.recipe_name)
    |> having([ri], count(ri.recipe_name) == ^length(ing_names))

    join(query, :inner, [r], ri in subquery(riq), ri.recipe_name == r.recipe_name)
  end
end
