defmodule BarchefDB.FavIngredient do
  use Ecto.Schema

  @primary_key false

  schema "fav_ingredient" do
    field :user_id, :integer
    field :ingredient_name, :string

    belongs_to :ingredient,
            BarchefDB.Ingredient,
            foreign_key: :ingredient_name, references: :ingredient_name, define_field: false

    belongs_to :user,
            BarchefDB.AppUser,
            foreign_key: :user_id, references: :user_id, define_field: false
  end
end
