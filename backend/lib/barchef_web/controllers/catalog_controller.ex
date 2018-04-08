defmodule BarchefWeb.CatalogController do
  use BarchefWeb, :controller
  import Ecto.Query
  alias Barchef.Repo
  alias BarchefDB.Catalog

  def index(conn, _params) do
    query = from cat in Catalog,
      select: cat.catalog,
      order_by: cat.catalog
    json conn, %{"data" => Repo.all(query)}
  end
end
