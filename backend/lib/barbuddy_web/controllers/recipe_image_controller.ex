defmodule BarBuddyWeb.RecipeImageController do
  use BarBuddyWeb, :controller
  alias BarBuddyDB.RecipeImage
  alias BarBuddyDB.Recipe
  alias BarBuddy.Repo

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
      %Recipe{} -> vessel_image(conn, recipe)
      nil ->
        conn
        |> send_resp(404, "")
    end
  end

  defp vessel_image(conn, %Recipe{:vessel => vessel}) do
    vessel_images = %{
      "Rocks" => "/image/vessel/oldfashioned.png",
      "Cocktail" => "/image/vessel/coupe.png",
      "Coupe" => "/image/vessel/coupe.png",
      "Martini" => "/image/vessel/coupe.png",
      "Highball" => "/image/vessel/highball.png",
      "Collins" => "/image/vessel/highball.png",
      "Snifter" => "/image/vessel/oldfashioned.png",
      "Hurricane" => "/image/vessel/hurricane.png",
      "Old Fashioned" => "/image/vessel/oldfashioned.png"
#      "Shot" => nil,
#      "Clear Plastic Bag" => nil,
#      "Cordial" => nil,
#      "Goblet" => nil,
#      "Flute" => nil,
#      "Copper Mug" => nil
    }

    vessel_uri = case Map.fetch(vessel_images, vessel) do
      {:ok, value} -> value
      {:error} -> "/image/vessel/coupe.png"
    end

    redirect(conn, to: vessel_uri)
  end

end
