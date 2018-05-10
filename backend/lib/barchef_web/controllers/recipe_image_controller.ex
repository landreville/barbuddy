defmodule BarchefWeb.RecipeImageController do
  use BarchefWeb, :controller
  alias BarchefDB.RecipeImage
  alias BarchefDB.Recipe
  alias Barchef.Repo

  def get(conn, %{"recipe_name" => recipe_name, "image_type" => image_type}) do
    ri = Repo.get_by(RecipeImage, recipe_name: recipe_name, image_type: image_type)

    case ri do
      nil -> recipe_default_image(conn, recipe_name)
      %RecipeImage{} ->
        conn
        |> put_resp_content_type(ri.mime_type)
        |> send_resp(200, ri.image)
    end
  end

  def update(conn, params) do

    recipe_image = Repo.get_by(
      RecipeImage,
      image_type: params["image_type"],
      recipe_name: params["recipe_name"]
    )

    case recipe_image do
      %RecipeImage{} ->
        changeset_render(
          conn,
          RecipeImage.changeset(recipe_image, params),
          &Repo.update/1
        )
      nil ->
        changeset_render(
          conn,
          RecipeImage.changeset(%RecipeImage{}, params),
          &Repo.insert/1
        )
    end
  end

  defp recipe_default_image(conn, recipe_name) do
    recipe = Repo.get_by(Recipe, recipe_name: recipe_name)
    case recipe do
      %Recipe{} -> vessel_image
      nil ->
        conn
        |> send_resp(404, "")
    end
  end

  defp vessel_image(%Recipe{:vessel => vessel}) do
    vessel_images = %{
      "Rocks" => "/image/vessel/oldfashioned.png",
      "Cocktail" => "/image/vessel/coupe.png",
      "Coupe" => "/image/vessel/coupe.png",
      "Martini" => "/image/vessel/coupe.png",
      "Shot" => nil,
      "Highball" => "/image/vessel/highball.png",
      "Collins" => "/image/vessel/highball.png",
      "Flute" => nil,
      "Copper Mug" => nil,
      "Snifter" => "/image/vessel/oldfashioned.png",
      "Cordial" => nil,
      "Goblet" => nil,
      "Hurricane" => "/image/vessel/hurricane.png",
      "Clear Plastic Bag" => nil,
      "Old Fashioned" => "/image/vessel/oldfashioned.png"
    }

    vessel_uri = case Map.fetch(vessel_images, vessel) do
      {:ok, value} -> value
      {:error} -> "/image/vessel/oldfashioned.png"
    end

    redirect(conn, to: vessel_uri)
  end

end
