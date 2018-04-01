defmodule BarchefDB.AppUser do
  use Ecto.Schema

  @primary_key false

  schema "appuser" do
    field :user_id, :integer, primary_key: true
    field :email, :string
    field :password, :string
    field :info, :map
    field :preferences, :map

    has_many :pantry_items,
             BarchefDB.PantryItem,
             foreign_key: :user_id, references: :user_id
    has_many :fav_recipes,
             BarchefDB.FavRecipe,
             foreign_key: :user_id, references: :user_id
    has_many :fav_ingredients,
             BarchefDB.FavIngredient,
             foreign_key: :user_id, references: :user_id
  end
end
