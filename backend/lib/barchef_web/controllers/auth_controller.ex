defmodule BarchefWeb.AuthController do
  use BarchefWeb, :controller
  alias Barchef.Auth.Auth
  alias Barchef.Auth.Guardian


  def login(conn, %{"email" => email, "password" => password}) do
    with {:ok, user} <- Auth.authenticate_user(email, password),
                {:ok, token} <- Auth.token_from_user(user)
    do
      %{"success" => true, "token" => token}
    else
      {:error, reason} -> %{"success" => false}
    end
    |> (fn data -> json conn, %{"data" => data} end).()
  end

  def refresh(conn, %{"token" => token}) do
    case Auth.refresh_token(token) do
      {:ok, token} -> %{"success" => true, "token" => token}
      {:error, reason} -> %{"success" => false}
    end
    |> (fn data -> json conn, %{"data" => data} end).()
  end
end
