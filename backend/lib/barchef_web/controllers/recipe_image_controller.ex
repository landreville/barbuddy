defmodule BarchefWeb.RecipeImageController do
  use BarchefWeb, :controller
  alias BarchefDB.RecipeImage
  alias Barchef.Repo

  def get(conn, %{"recipe_name" => recipe_name, "image_type" => image_type}) do
    ri = Repo.get_by(RecipeImage, recipe_name: recipe_name, image_type: image_type)

    case ri do
      nil -> conn |> send_resp(404, "")
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

end
