defmodule BarchefDB.Ingredient do
  use Ecto.Schema

  @primary_key false

  schema "ingredient" do
    field :ingredient_name, :string, primary_key: true
    field :parent_ingredient_name, :string
    field :description, :string
    field :approved, :boolean, default: false

    has_many :recipe_ingredients,
             BarchefDB.RecipeIngredient,
             foreign_key: :ingredient_name, references: :ingredient_name

    has_many :substitutes,
             BarchefDB.Substitute,
             foreign_key: :ingredient_name, references: :ingredient_name

    has_many :child_ingredients,
             BarchefDB.Ingredient,
             foreign_key: :parent_ingredient_name, references: :ingredient_name

    has_one :parent_ingredient,
            BarchefDB.Ingredient,
            foreign_key: :ingredient_name, references: :parent_ingredient_name
  end
end


