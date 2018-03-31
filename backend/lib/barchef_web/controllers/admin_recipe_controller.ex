defmodule BarchefWeb.AdminRecipeController do
  use BarchefWeb, :controller
  alias BarchefDB.Recipe, as: Recipe
  alias Barchef.Repo, as: Repo
  import Ecto.Changeset

  def index(conn, _params) do
    json conn, %{"data" => []}
  end

  def get(conn, %{"id" => id}) do
    json conn, %{"data" => %{}}
  end

  def add(conn, params) do
    Logger.info "#{inspect params}"
    changeset = Recipe.changeset(%Recipe{}, params)
    case Repo.insert(changeset) do
      {:ok, %Recipe{}=recipe} -> json conn, %{"data" => %{"success" => true}}
      {:error, cs} ->
        Logger.warn "Raw Errors: #{inspect cs.errors}"
        errors = change_errors_to_map(cs)
        Logger.warn "Error: #{inspect errors}"
        json conn, %{"data" => %{"success" => false, "error" => errors}}
    end
  end

  def change_errors_to_map(%Ecto.Changeset{:errors => errors}) do
    errors
    |> Enum.map(fn({field, {message, error_list}}) -> {field, message} end)
    |> Map.new
  end

  def update(conn, params) do
    json conn, %{"data" => %{"success" => true}}
  end
end
