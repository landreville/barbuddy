defmodule BarchefDB.Vessel do
  use Ecto.Schema

  @primary_key false

  schema "vessel" do
    field :vessel, :string, primary_key: true
  end
end
