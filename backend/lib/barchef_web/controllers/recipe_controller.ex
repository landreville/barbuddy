defimpl Poison.Encoder, for: Any do
  def encode(%{__struct__: _} = struct, options) do
    map = struct
          |> Map.from_struct
          |> sanitize_map
    Poison.Encoder.Map.encode(map, options)
  end

  defp sanitize_map(map) do
    # TODO: remove associations that are not loaded
    Map.drop(map, [:__meta__, :__struct__])
  end
end

defmodule BarchefWeb.RecipeController do
  use BarchefWeb, :controller
  alias BarchefDB.Recipe
  alias BarchefDB.RecipeIngredient
  alias Barchef.Repo, as: Repo
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
    changeset_render(conn, %Recipe{}, params, &Repo.insert/1)
  end

  def update(conn, params) do
    recipe = Repo.get(Recipe, params["id"])
    changeset_render(conn, recipe, params, &Repo.update/1)
  end

  defp changeset_render(conn, recipe, params, action) do
    changeset = Recipe.changeset(recipe, params)
    case action.(changeset) do
      {:ok, _record} -> json conn, %{"data" => %{"success" => true}}
      {:error, cs} ->
        Logger.warn "Errors inserting/updating recipe. " <>
                    "Action: #{inspect action}. Errors: #{inspect cs.errors}"
        errors = change_errors_to_map(cs)
        json conn, %{"data" => %{"success" => false, "error" => errors}}
    end
    json conn, %{"data" => %{"success" => false}}
  end

  defp change_errors_to_map(%Ecto.Changeset{:errors => errors}) do
    errors
    |> Enum.map(fn({field, {message, _error_list}}) -> {field, message} end)
    |> Map.new
  end
end
