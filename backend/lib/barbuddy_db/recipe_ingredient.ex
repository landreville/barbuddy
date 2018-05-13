defmodule BarBuddyDB.RecipeIngredient do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  schema "recipe_ingredient" do
    field :recipe_name, :string, primary_key: true
    field :ingredient_name, :string, primary_key: true
    field :amount, :decimal
    field :unit, :string
    field :garnish, :boolean, default: false
    field :optional, :boolean, default: false

    belongs_to :ingredient,
            BarBuddyDB.Ingredient,
            foreign_key: :ingredient_name, references: :ingredient_name,
            define_field: false, on_replace: :update

    belongs_to :recipe,
            BarBuddyDB.Recipe,
            foreign_key: :recipe_name, references: :recipe_name,
            define_field: false, on_replace: :update
  end

  def exclude_fields, do: [:recipe_name]

  def changeset(recipe_ingredient, params \\ %{}) do
    recipe_ingredient
    |> cast(params, [:recipe_name, :ingredient_name, :amount, :unit, :garnish, :optional])
  end
end
