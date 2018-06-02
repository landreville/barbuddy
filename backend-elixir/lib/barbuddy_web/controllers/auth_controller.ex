# TODO: remove
defmodule BarBuddyWeb.AuthController do
  use BarBuddyWeb, :controller
  alias BarBuddy.Auth
  alias BarBuddyDB.AppUser
  alias BarBuddy.Auth.Guardian
  alias Guardian.Token.Jwt
  alias JOSE.JWT
  alias JOSE.JWK
  alias BarBuddy.Auth.SecretFetcher
  alias Poison
  require Logger

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


  def verify(conn, %{"access_token" => access_token}) do
    Logger.info "Access Token: #{inspect access_token}"
    result = Guardian.decode_and_verify(access_token)

    success = case result do
      {:ok, _} -> true
      {:error, reason} ->
        Logger.info "Failed due to: #{inspect reason}"
        false
    end
    
    render conn, "success.json", success: success
  end
end
