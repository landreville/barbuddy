defmodule BarchefDB.Catalog do
  use Ecto.Schema

  @primary_key false

  schema "catalog" do
    field :catalog, :string, primary_key: true
  end
end
