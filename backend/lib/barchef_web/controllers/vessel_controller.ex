defmodule BarchefWeb.VesselController do
  use BarchefWeb, :controller
  import Ecto.Query
  alias Barchef.Repo
  alias BarchefDB.Vessel

  def index(conn, _params) do
    query = from item in Vessel,
      select: item.vessel,
      order_by: item.vessel
    json conn, %{"data" => Repo.all(query)}
  end
end