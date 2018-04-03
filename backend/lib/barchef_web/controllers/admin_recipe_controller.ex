defmodule BarchefWeb.AdminRecipeController do
  use BarchefWeb, :controller
  alias BarchefDB.Recipe, as: Recipe
  alias Barchef.Repo, as: Repo

  def index(conn, _params) do
    json conn, %{"data" => []}
  end

  def get(conn, %{"id" => _id}) do
    json conn, %{"data" => %{}}
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
