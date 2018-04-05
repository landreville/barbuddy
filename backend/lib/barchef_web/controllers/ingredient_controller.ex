defmodule BarchefWeb.IngredientController do
  use BarchefWeb, :controller
  import Ecto.Query
  alias Barchef.Repo

  def ingredients(conn, _params) do
    query = from ing in "ingredient",
      select: ing.ingredient_name,
      order_by: ing.ingredient_name
    json conn, %{"data" => Repo.all(query)}
  end
end
