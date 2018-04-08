defmodule BarchefDB.RecipeImage do
  require Logger
  use Ecto.Schema
  import Ecto.Changeset
  require Fastimage

  @primary_key false

  schema "recipe_image" do
    field :recipe_name, :string, primary_key: true
    field :image_type, :string, primary_key: true
    field :width, :integer
    field :height, :integer
    field :mime_type, :string
    field :filename, :string
    field :image, :binary
    field :image_file, :any, virtual: true
  end

  def changeset(recipe_image, params \\ {}) do
    recipe_image
    |> cast(params, [:recipe_name, :image_type, :image_file])
    |> validate_image_type
    |> add_image
  end

  defp validate_image_type(changeset) do
    changeset
    |> validate_inclusion(:image_type, ["main", "thumbnail"])
  end

  defp add_image(changeset) do
    image_file = get_change(changeset, :image_file)
    info = Fastimage.info!(image_file.path)
    Logger.info "#{inspect info}"
    changeset
    |> put_change(:mime_type, image_file.content_type)
    |> put_change(:width, info.dimensions.width)
    |> put_change(:height, info.dimensions.height)
    |> put_change(:mime_type, "image/#{Atom.to_string(info.image_type)}")
    |> add_image_data(image_file.path)
  end

  defp add_image_data(changeset, path) do
    file = File.open! path
    put_change(changeset, :image, IO.binread(file, :all))
  end
end

