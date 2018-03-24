defmodule BarchefWeb.AdminIngredientController do
  use BarchefWeb, :controller

  @view_map %{
    "all" => "all-ingredients",
    "active" => "ingredients",
  }

  def ingredients(conn, _params) do
    fetch_ingredients(conn, @view_map["all"])
  end

  def ingredients_view(conn, %{"view" => view}) do
    case @view_map do
      %{^view => path} -> fetch_ingredients(conn, path)
      _ -> conn |> put_status(:not_found)
    end
  end

  defp fetch_ingredients(conn, path) do
    case fetch(path, %{"group" => "true"}) do
      {:ok, data} ->
        json conn, %{"data" => Enum.map(data, &(&1["key"]))}
      {:error, message} ->
        Logger.warn "Error: " <> message
        conn |> put_status(500)
    end
  end
end
