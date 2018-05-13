defmodule BarBuddyWeb.IngredientController do
  use BarBuddyWeb, :controller
  import Ecto.Query
  alias BarBuddy.Repo

  def ingredients(conn, _params) do
    query = from ing in "ingredient",
      select: ing.ingredient_name,
      order_by: ing.ingredient_name
    render conn, "data.json", data: Repo.all(query)
  end
end
