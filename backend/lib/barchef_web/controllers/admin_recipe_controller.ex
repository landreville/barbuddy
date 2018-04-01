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
    changeset = Recipe.changeset(%Recipe{}, params)

    case Repo.insert(changeset) do
      {:ok, _record} -> json conn, %{"data" => %{"success" => true}}
      {:error, cs} ->
        Logger.warn "Raw Errors: #{inspect cs.errors}"
        errors = change_errors_to_map(cs)
        json conn, %{"data" => %{"success" => false, "error" => errors}}
    end
    json conn, %{"data" => %{"success" => false}}
  end

  def change_errors_to_map(%Ecto.Changeset{:errors => errors}) do
    errors
    |> Enum.map(fn({field, {message, _error_list}}) -> {field, message} end)
    |> Map.new
  end

  def update(conn, _params) do
    json conn, %{"data" => %{"success" => true}}
  end
end
