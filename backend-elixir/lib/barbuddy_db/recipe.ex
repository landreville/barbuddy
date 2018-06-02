defmodule BarBuddyDB.Recipe do
  use BarBuddyDB.Base
  require Logger
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias BarBuddy.Repo
  alias BarBuddyDB.Ingredient
  alias BarBuddyDB.RecipeIngredient

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
    params = add_id_to_recipe_ingredients(params)

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
    |> sync_recipe_ingredients
    |> remove_recipe_ingredients
  end


  defp add_id_to_recipe_ingredients(params) do
    %{
      "recipe_ingredients" => recipe_ingredients,
      "recipe_name" => recipe_name
    } = params
    Enum.map(recipe_ingredients, &(Map.put(&1, "recipe_name", recipe_name)))
    |> (fn (ri) -> Map.put(params, "recipe_ingredients", ri) end).()
  end

  defp sync_recipe_ingredients(changeset) do
    changeset.params["recipe_ingredients"]
    |> Enum.map(&(Map.put(&1, "recipe_name", changeset.params["recipe_name"])))
    |> Enum.map(&add_missing_ingredient/1)
    |> Enum.map(&add_update_recipe_ingredient/1)
    changeset
  end

  defp add_update_recipe_ingredient(ri_param) do
    ri = get_recipe_ingredient(ri_param)

    if ri == nil do
      RecipeIngredient.changeset(%RecipeIngredient{}, ri_param)
      |> Repo.insert
    else
      RecipeIngredient.changeset(ri, ri_param)
      |> Repo.update
    end
    ri_param
  end

  defp get_recipe_ingredient(ri_param) do
    query = from ri in RecipeIngredient,
         where: ri.recipe_name == ^ri_param["recipe_name"]
            and ri.ingredient_name == ^ri_param["ingredient_name"]

    Repo.one(query)
  end

  defp add_missing_ingredient(ri_param) do
    %{"ingredient_name" => ingredient_name} = ri_param
    unless ingredient_exists? ingredient_name do
      Ingredient.changeset(%Ingredient{}, %{:ingredient_name => ingredient_name})
      |> Repo.insert
    end
    ri_param
  end

  defp ingredient_exists?(ingredient_name) do
    from(i in "ingredient", where: i.ingredient_name == ^ingredient_name)
    |> Repo.aggregate(:count, :ingredient_name)
    |> (fn (cnt) -> cnt > 0 end).()
  end

  defp remove_recipe_ingredients(changeset) do
    if changeset.data.recipe_name != nil do
      recipe_name = changeset.data.recipe_name
      new_ri = Enum.map(changeset.params["recipe_ingredients"], &(&1["ingredient_name"]))

      query = from ri in "recipe_ingredient",
                   where: ri.recipe_name == ^recipe_name
                   and ri.ingredient_name not in ^new_ri

      Repo.delete_all(query)
    end

    changeset
  end

end
