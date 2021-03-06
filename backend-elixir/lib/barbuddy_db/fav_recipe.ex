defmodule BarBuddyDB.FavRecipe do
  use Ecto.Schema

  @primary_key false

  schema "fav_recipe" do
    field :user_id, :integer
    field :recipe_name, :string

    belongs_to :recipe,
            BarBuddyDB.Recipe,
            foreign_key: :recipe_name, references: :recipe_name, define_field: false

    belongs_to :user,
            BarBuddyDB.AppUser,
            foreign_key: :user_id, references: :user_id, define_field: false
  end
end
