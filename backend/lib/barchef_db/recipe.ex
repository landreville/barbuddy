defmodule BarchefDB.Recipe do
  use Ecto.Schema
  import Ecto.Changeset
  alias Barchef.Repo, as: Repo

  @primary_key false

  schema "recipe" do
    field :recipe_name, :string, primary_key: true
    field :vessel, :string
    field :description, :string
    field :catalog, :string
    field :category, :string
    field :directions, :string
    field :story, :string
    field :active, :boolean, default: false
    field :created, :naive_datetime
    field :photo_path, :string

    has_many :recipe_ingredients,
             BarchefDB.RecipeIngredient,
             foreign_key: :recipe_name, references: :recipe_name
  end

  def changeset(recipe, params \\ %{}) do
    recipe
    |> Repo.preload(:recipe_ingredients)
    |> cast(params, [:recipe_name, :description, :catalog, :category, :directions, :story])
    |> validate_required([:recipe_name, :description, :directions])
    |> unique_constraint(:recipe_name)
    |> foreign_key_constraint(:catalog)
    |> foreign_key_constraint(:category)
    |> foreign_key_constraint(:vessel)
    |> cast_assoc(:recipe_ingredients)
  end
end

