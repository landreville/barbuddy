defmodule BarBuddyWeb.CategoryController do
  use BarBuddyWeb, :controller
  import Ecto.Query
  alias BarBuddy.Repo
  alias BarBuddyDB.Category

  def index(conn, _params) do
    query = from cat in Category,
      select: cat.category,
      order_by: cat.category
    render conn, "data.json", data: Repo.all(query)
  end
end
