defmodule BarchefWeb.CategoryController do
  use BarchefWeb, :controller
  import Ecto.Query
  alias Barchef.Repo
  alias BarchefDB.Category

  def index(conn, _params) do
    query = from cat in Category,
      select: cat.category,
      order_by: cat.category
    json conn, %{"data" => Repo.all(query)}
  end
end
