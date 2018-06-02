defmodule BarBuddyDB.AppUser do
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt

  @primary_key false

  schema "appuser" do
    field :user_id, :integer, primary_key: true
    field :display_name, :string
    field :email, :string
    field :email_verified, :boolean
    field :photo_url, :string
    field :google_uid, :string
    field :provider_data, :map
    field :password, :string
    field :info, :map
    field :preferences, :map
    field :admin, :boolean, default: false

    has_many :pantry_items,
             BarBuddyDB.PantryItem,
             foreign_key: :user_id, references: :user_id
    has_many :fav_recipes,
             BarBuddyDB.FavRecipe,
             foreign_key: :user_id, references: :user_id
    has_many :fav_ingredients,
             BarBuddyDB.FavIngredient,
             foreign_key: :user_id, references: :user_id
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :email_verified, :photo_url, :google_uid, :provider_data])
    |> validate_required([:email])
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hashpwsalt(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
