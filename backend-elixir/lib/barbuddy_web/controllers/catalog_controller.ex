defmodule BarBuddyWeb.CatalogController do
  use BarBuddyWeb, :controller
  import Ecto.Query
  alias BarBuddy.Repo
  alias BarBuddyDB.Catalog

  def index(conn, _params) do
    query = from cat in Catalog,
      select: cat.catalog,
      order_by: cat.catalog
    render conn, "data.json", data: Repo.all(query)
  end
end
