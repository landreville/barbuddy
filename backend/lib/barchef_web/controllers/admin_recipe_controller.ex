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
    },
    "id" => %{
      "all" => "all-recipes-by-id"
    }
  }

  def update(conn, params) do
#    validate_recipe(params)
#    %{"_id" => id, "_rev" => rev} = fetch_recipe(params["_id"])
    case update_recipe(params) do
      {:ok, data} -> json conn, %{"success" => true, "data" => data}
      {:error, message} -> json conn, %{"success" => false, "message" => message}
    end
  end

  def get_image(conn, %{"id" => id, "filename" => filename}) do
    case fetch_image(id, filename) do
      { :ok, resp } ->
        %{"Content-Type" => content_type} = Map.new(resp.headers)
        conn
         |> put_resp_content_type(content_type)
         |> send_resp(resp.status_code, resp.body)
      { :error, _error } ->
        conn
          |> put_status(:bad_gateway)
          |> text "Error"
    end
  end

  def update_image(conn, %{"id" => id, "image" => image}) do
    ext = String.split(image.content_type, "/") |> Enum.at(-1)
    filename = "main.#{ext}"
    %{"_rev" => update_rev} = fetch_recipe(id)
    case update_recipe_image(id, update_rev, image, filename) do
      {:ok,  %{"rev" => rev}} ->
        recipe = fetch_recipe(id)
                 |> Map.put("image", filename)
                 |> Map.put("thumbnail", filename)
        case update_recipe(Map.put(recipe, "_rev", rev)) do
          {:ok, _} -> Logger.info "Updated image on recipe."
          {:error, message} ->
            Logger.warn "#{inspect recipe}"
            Logger.warn "Error updating recipe: #{inspect message}"
        end
      {:error, message} ->
        Logger.warn "Error uploading image: #{inspect message}"
    end
    json conn, %{"success" => true}
  end

  defp make_id(recipe) do
    %{"name" => name} = recipe
    id = name |> String.downcase |> String.replace("[^a-z0-9-]+", "-")
    check_id(recipe, id)
  end

  defp check_id(recipe, id, i \\ 0) do
    if i > 0 do
      next_id = id <> i
    else
      next_id = id
    end
    case fetch_recipe(next_id) do
      nil -> Map.merge(%{"id" => next_id}, recipe)
      _ -> check_id(recipe, id, i+1)
    end
  end

  defp validate_recipe(recipe) do
    %{
      "name" => name,
      "description" => description,
      "directions" => directions,
      "ingredients" => ingredients
    } = recipe
    Enum.map(ingredients, &validate_ingredient/1)
  end

  defp validate_ingredient(ing) do
    %{"name" => name} = ing
  end

  def recipe(conn, %{"id" => id}) do
    fetch_recipes(conn, "id", "all", %{"key" => Jason.encode!(id)}, &(Enum.at(&1, 0)))
  end

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

  def recipes_view(conn, %{"view" => view}) do
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

  defp fetch_recipe(id) do
    {:ok, recipe} = fetch("all-recipes-by-id", %{"key" => Jason.encode!(id)})
    Enum.at(recipe, 0)
  end

  defp fetch_recipes(conn, category, view, params \\ [], data_fn \\ &(&1)) do
    case view_path(category, view) do
      {:ok, path} ->
        render_fetch(conn, path, params, &(data_fn.(&1)))
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
