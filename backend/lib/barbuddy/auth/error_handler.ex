defmodule BarBuddy.Auth.ErrorHandler do
  import Plug.Conn
  require Logger

  def auth_error(conn, {type, _reason}, _opts) do
    body = to_string(type)
    Logger.warn("Authentication error: #{body}")
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(401, "Unauthorized")
  end
end
