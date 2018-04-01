defmodule BarchefDB.Recipe do
  require Logger
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
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
    field :inserted_at, :naive_datetime
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
    |> add_missing_ingredients
    |> cast_assoc(:recipe_ingredients)
  end

  defp add_missing_ingredients(changeset) do
    # TODO: use ingredient changeset
    changeset.params["recipe_ingredients"]
    |> Enum.map(&add_missing_ingredient/1)

    changeset
  end

  defp add_missing_ingredient(recipe_ingredient) do
    %{"ingredient_name" => ingredient_name} = recipe_ingredient
    unless ingredient_exists? ingredient_name do
      Repo.insert(%BarchefDB.Ingredient{:ingredient_name => ingredient_name})
    end
  end

  defp ingredient_exists?(ingredient_name) do
    from(i in "ingredient", where: i.ingredient_name == ^ingredient_name)
    |> Repo.aggregate(:count, :ingredient_name)
    |> (fn(cnt) -> cnt > 0 end).()
  end

end

