defmodule BarchefDB.AppUser do
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt

  @primary_key false

  schema "appuser" do
    field :user_id, :integer, primary_key: true
    field :email, :string
    field :password, :string
    field :info, :map
    field :preferences, :map
    field :admin, :boolean, default: false

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

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hashpwsalt(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
