defmodule BarchefDB.Substitute do
  use Ecto.Schema

  @primary_key false

  schema "substitute" do
    field :ingredient_name, :string
    field :sub_ingredient_name, :string
    field :ratio, :float, default: 1

    has_one :ingredient,
            BarchefDB.Ingredient,
            foreign_key: :ingredient_name, references: :ingredient_name

    has_one :sub_ingredient,
            BarchefDB.Ingredient,
            foreign_key: :ingredient_name, references: :sub_ingredient_name
  end
end
