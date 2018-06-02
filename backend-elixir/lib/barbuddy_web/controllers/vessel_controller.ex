defmodule BarBuddyWeb.VesselController do
  use BarBuddyWeb, :controller
  import Ecto.Query
  alias BarBuddy.Repo
  alias BarBuddyDB.Vessel

  def index(conn, _params) do
    query = from item in Vessel,
      select: item.vessel,
      order_by: item.vessel
    render conn, "data.json", data: Repo.all(query)
  end
end
