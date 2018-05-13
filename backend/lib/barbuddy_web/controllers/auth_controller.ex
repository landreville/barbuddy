defmodule BarBuddyWeb.AuthController do
  use BarBuddyWeb, :controller
  alias BarBuddy.Auth

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
    render conn, "data.json", data: data
  end
end
