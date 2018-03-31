defmodule BarchefDB.FavRecipe do
  use Ecto.Schema

  @primary_key false

  schema "fav_recipe" do
    field :user_id, :integer
    field :recipe_name, :string

    has_one :recipe,
            BarchefDB.Recipe,
            foreign_key: :recipe_name, references: :recipe_name

    has_one :user,
            BarchefDB.AppUser,
            foreign_key: :user_id, references: :user_id
  end
end

defmodule BarchefDB.FavIngredient do
  use Ecto.Schema

  @primary_key false

  schema "fav_ingredient" do
    field :user_id, :integer
    field :ingredient_name, :string

    has_one :ingredient,
            BarchefDB.Ingredient,
            foreign_key: :ingredient_name, references: :ingredient_name

    has_one :user,
            BarchefDB.AppUser,
            foreign_key: :user_id, references: :user_id
  end
end

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

defmodule BarchefDB.PantryItem do
  use Ecto.Schema

  @primary_key false

  schema "pantry" do
    field :user_id, :integer, primary_key: true
    field :ingredient_name, :string, primary_key: true
    field :amount, :float
    field :unit, :string

    has_one :ingredient,
            BarchefDB.Ingredient,
            foreign_key: :ingredient_name, references: :ingredient_name

    has_one :user,
            BarchefDB.AppUser,
            foreign_key: :user_id, references: :user_id
  end
end


