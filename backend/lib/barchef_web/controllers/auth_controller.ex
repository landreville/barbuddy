defmodule BarchefWeb.AuthController do
  use BarchefWeb, :controller
  alias Barchef.Auth

  def login(conn, %{"email" => email, "password" => password}) do
    with {:ok, user} <- Auth.authenticate_user(email, password),
                {:ok, token} <- Auth.token_from_user(user)
    do
      %{"success" => true, "token" => token}
    else
      {:error, _reason} -> %{"success" => false}
    end
    |> json_data(conn)
  end

  def refresh(conn, %{"token" => token}) do
    case Auth.refresh_token(token) do
      {:ok, token} -> %{"success" => true, "token" => token}
      {:error, _reason} -> %{"success" => false}
    end
    |> json_data(conn)
  end

  defp json_data(data, conn) do
    # TODO: use a view that calls json and wraps with data key
    json conn, %{"data" => data}
  end
end
