defmodule BarchefWeb.AdminCatalogController do
  use BarchefWeb, :controller

  def catalogs(conn, _params) do
    case fetch("all-catalogs", %{"group" => "true"}) do
      {:ok, data} ->
        json conn, %{"data" => data}
      {:error, message} ->
        Logger.warn "Error: " <> message
        conn |> put_status(500)
    end
  end

  def catalogs_recipes(conn, %{"catalog" => catalog}) do
    json conn,
         %{
           "data" => fetch(
             "all-recipes-by-catalog",
             %{"key" => Jason.encode!(catalog)}
           )
         }
  end
end
