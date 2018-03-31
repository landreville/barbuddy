defmodule BarchefDB.Category do
  use Ecto.Schema

  @primary_key false

  schema "recipe_category" do
    field :category, :string, primary_key: true
  end
end
