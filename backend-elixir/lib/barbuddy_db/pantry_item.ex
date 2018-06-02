defmodule BarBuddyDB.PantryItem do
  use Ecto.Schema

  @primary_key false

  schema "pantry" do
    field :user_id, :integer, primary_key: true
    field :ingredient_name, :string, primary_key: true
    field :amount, :float
    field :unit, :string

    belongs_to :ingredient,
            BarBuddyDB.Ingredient,
            foreign_key: :ingredient_name, references: :ingredient_name, define_field: false

    belongs_to :user,
            BarBuddyDB.AppUser,
            foreign_key: :user_id, references: :user_id, define_field: false
  end
end
