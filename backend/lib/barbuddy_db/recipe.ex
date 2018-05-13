defmodule BarBuddyDB.Recipe do
  use BarBuddyDB.Base
  require Logger
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias BarBuddy.Repo, as: Repo
  alias BarBuddyDB.Ingredient, as: Ingredient

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
             BarBuddyDB.RecipeIngredient,
             foreign_key: :recipe_name,
             references: :recipe_name,
             on_replace: :mark_as_invalid
  end

  def exclude_fields, do: [:active, :inserted_at, :photo_path]

  def changeset(recipe, params \\ %{}) do
    params = if recipe.recipe_name != nil do
      params
      |> add_id_to_recipe_ingredients
    else
      params
    end

    recipe
    |> Repo.preload(:recipe_ingredients)
    |> cast(
         params,
         [:recipe_name, :description, :catalog, :category, :directions, :story, :vessel]
       )
    |> validate_required([:recipe_name, :description, :directions])
    |> unique_constraint(:recipe_name)
    |> foreign_key_constraint(:catalog)
    |> foreign_key_constraint(:category)
    |> foreign_key_constraint(:vessel)
    |> add_missing_ingredients
    |> cast_assoc(:recipe_ingredients)
    |> remove_recipe_ingredients
  end

  defp add_id_to_recipe_ingredients(params) do
    %{
      "recipe_ingredients" => old_ri,
      "recipe_name" => recipe_name
    } = params
    Enum.map(old_ri, &(Map.put(&1, "recipe_name", recipe_name)))
    |> (fn (ri) -> Map.put(params, "recipe_ingredients", ri) end).()
  end

  defp add_missing_ingredients(changeset) do
    changeset.params["recipe_ingredients"]
    |> Enum.map(&add_missing_ingredient/1)

    changeset
  end

  defp add_missing_ingredient(recipe_ingredient) do
    %{"ingredient_name" => ingredient_name} = recipe_ingredient
    unless ingredient_exists? ingredient_name do
      Ingredient.changeset(%Ingredient{}, %{:ingredient_name => ingredient_name})
      |> Repo.insert
    end
  end

  defp ingredient_exists?(ingredient_name) do
    from(i in "ingredient", where: i.ingredient_name == ^ingredient_name)
    |> Repo.aggregate(:count, :ingredient_name)
    |> (fn (cnt) -> cnt > 0 end).()
  end

  defp remove_recipe_ingredients(changeset) do
    if changeset.data.recipe_name != nil do
      recipe_name = changeset.data.recipe_name
      new_ri = for ri_map <- changeset.params["recipe_ingredients"],
                   do: ri_map["ingredient_name"]

      query = from ri in "recipe_ingredient",
                   where: ri.recipe_name == ^recipe_name
                   and ri.ingredient_name not in ^new_ri

      Repo.delete_all(query)
    end

    changeset
  end

end
