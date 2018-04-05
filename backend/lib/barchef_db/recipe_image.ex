defmodule BarchefDB.RecipeImage do
  require Logger
  use Ecto.Schema

  schema "recipe_image" do
    field :recipe_name, :string
    field :image_type, :string
    field :width, :float
    field :height, :float
    field :mime_type, :string
    field :image, :binary
  end
end
