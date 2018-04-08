defmodule BarchefWeb.RecipeImageController do
  use BarchefWeb, :controller
  alias BarchefDB.RecipeImage
  alias Barchef.Repo
  import Ecto.Query

  def get(conn, %{"recipe_name" => recipe_name, "image_type" => image_type}) do
     ri = Repo.get_by(RecipeImage, recipe_name: recipe_name, image_type: image_type)

     conn
     |> put_resp_content_type(ri.mime_type)
     |> send_resp(200, ri.image)
  end

  def update(conn, params) do

    q = from ri in RecipeImage,
      where: ri.image_type == ^params["image_type"]
        and ri.recipe_name == ^params["recipe_name"]
    cnt = Repo.aggregate(q, :count, :recipe_name)

    repo_fun = case cnt do
      0 -> &Repo.insert/1
      _ -> &Repo.update/1
    end

    changeset_render(conn, RecipeImage.changeset(%RecipeImage{}, params), repo_fun)
  end

end
