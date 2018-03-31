defmodule BarchefDB.RecipeIngredient do
  use Ecto.Schema
  import Ecto.Changeset
  alias Barchef.Repo, as: Repo
  alias BarchefDB.Ingredient, as: Ingredient

  @primary_key false

  schema "recipe_ingredient" do
    field :recipe_name, :string, primary_key: true
    field :ingredient_name, :string, primary_key: true
    field :amount, :float
    field :unit, :string
    field :garnish, :boolean, default: false
    field :optional, :boolean, default: false

    has_one :ingredient,
            BarchefDB.Ingredient,
            foreign_key: :ingredient_name, references: :ingredient_name

    has_one :recipe,
            BarchefDB.Recipe,
            foreign_key: :recipe_name, references: :recipe_name
  end

  def changeset(recipe_ingredient, params \\ %{}) do
    recipe_ingredient
    |> Repo.preload(:ingredient)
    |> cast(params, [:recipe_name, :ingredient_name, :amount, :unit, :garnish, :optional])
    |> validate_required([:recipe_name, :ingredient_name])
    |> put_assoc(:ingredient, %Ingredient{:ingredient_name => params[:ingredient_name]})
  end
end
