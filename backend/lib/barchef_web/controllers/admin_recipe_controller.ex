defmodule BarchefWeb.AdminRecipeController do
  use BarchefWeb, :controller

  @view_maps %{
    "name" => %{
      "all" => "all-recipes-by-name",
      "active" => "recipes-by-name",
      "unpublished" => "unpublished-recipes-by-name"
    },
    "ingredients" => %{
      "all" => "all-recipes-by-ingredient",
      "active" => "recipes-by-ingredient",
      "unpublished" => "unpublished-recipes-by-ingredient"
    }
  }

  def recipes(conn, params) do
    case params do
      %{"ingredients" => ingredients} ->
        case fetch_by_ingredients("all", Jason.decode!(ingredients)) do
          {:ok, data} -> json conn, %{"data" => data}
          {:error, _message} -> conn |> put_status(:not_found)
        end
      _ -> fetch_recipes(conn, "name", "all")
    end

  end

  def recipes(conn, %{"view" => view}) do
    fetch_recipes(conn, "name", view)
  end

  defp fetch_by_ingredients(view, ingredients) do
    case view_path("ingredients", view) do
      {:ok, path} ->
        {
          :ok,
          map_fetch_by_ingredients(path, ingredients)
          |> intersect_recipes
        }
      {:error, message} -> {:error, message}
    end
  end

  defp map_fetch_by_ingredients(path, [head | tail]) do
    case fetch(path, %{"key" => Jason.encode!(head)}) do
      {:ok, data} -> [data | map_fetch_by_ingredients(path, tail)]
      {:error, message} ->
        Logger.warn message
        head
    end
  end

  defp map_fetch_by_ingredients(_path, []) do
    []
  end

  defp intersect_recipes(recipe_lists) do
    # List of ids that appear in every list of recipes
    ids = recipe_lists
      |> Enum.map(&recipes_to_ids/1)
      |> Enum.map(&MapSet.new/1)
      |> Enum.reduce(&MapSet.intersection/2)
      |> MapSet.to_list

    # Only recipes that have ids above
    recipe_lists
      |> Enum.concat
      |> Enum.filter(&(Enum.member?(ids, &1["id"])))
      |> Enum.uniq_by(&(&1["id"]))
  end

  defp recipes_to_ids(recipes) do
    for r <- recipes, do: r["id"]
  end

  defp fetch_recipes(conn, category, view) do
    case view_path(category, view) do
      {:ok, path} ->
        render_fetch(conn, path)
      {:error, _message} ->
        conn
        |> put_status(:not_found)
    end
  end

  defp view_path(category, view) do
    %{^category => view_map} = @view_maps

    case view_map do
      %{^view => path} -> {:ok, path}
      _ ->
        Logger.warn "Invalid view specified: " <> view
        {:error, "Invalid view specified: " <> view}
    end
  end
end
