defmodule BarBuddyDB.Ingredient do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  schema "ingredient" do
    field :ingredient_name, :string, primary_key: true
    field :parent_ingredient_name, :string
    field :description, :string
    field :approved, :boolean, default: false

    has_many :recipe_ingredients,
             BarBuddyDB.RecipeIngredient,
             foreign_key: :ingredient_name, references: :ingredient_name

    has_many :substitutes,
             BarBuddyDB.Substitute,
             foreign_key: :ingredient_name, references: :ingredient_name

    has_many :child_ingredients,
             BarBuddyDB.Ingredient,
             foreign_key: :parent_ingredient_name, references: :ingredient_name

    has_one :parent_ingredient,
            BarBuddyDB.Ingredient,
            foreign_key: :ingredient_name, references: :parent_ingredient_name
  end

  def exclude_fields, do: [:approved]

  def changeset(ingredient, params \\ %{}) do
    ingredient
    |> cast(params, [:ingredient_name, :description, :parent_ingredient_name])
  end
end


