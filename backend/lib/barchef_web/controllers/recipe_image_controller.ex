defmodule BarchefWeb.RecipeImageController do
  use BarchefWeb, :controller
  alias BarchefDB.Recipe, as: Recipe
  alias Barchef.Repo, as: Repo

  def get(conn, %{"id" => _id}) do
    json conn, %{"data" => %{}}
  end

  def update(conn, params) do
  end
end
