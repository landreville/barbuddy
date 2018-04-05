defmodule BarchefWeb.CatalogController do
  use BarchefWeb, :controller
  import Ecto.Query
  alias Barchef.Repo

  def catalogs(conn, _params) do
    query = from cat in "catalog",
      select: cat.catalog,
      order_by: cat.catalog
    json conn, %{"data" => Repo.all(query)}
  end
end
