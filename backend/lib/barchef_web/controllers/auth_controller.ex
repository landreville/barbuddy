defmodule BarchefWeb.AuthController do
  use BarchefWeb, :controller
  alias Barchef.Auth.Auth
  alias Barchef.Auth.Guardian


  def login(conn, %{"email" => email, "password" => password}) do
    Auth.authenticate_user(email, password)
    |> login_reply
    |> (fn data -> json(conn, %{"data" => data}) end).()
  end

  defp login_reply({:ok, user}) do
    token = Auth.token_from_user(user)
    %{"success" => true, "token" => token}
  end

  defp login_reply({:error, _error}) do
    %{"success" => false}
  end

  def refresh(conn, %{"token" => token}) do
    {:ok, _claims} = Guardian.decode_and_verify(token)
    {:ok, _old_stuff, {new_token, _new_claims}} = Guardian.refresh(token)
    {:ok, _old_stuff, {new_token, _new_claims}} = Guardian.exchange(new_token, "refresh", "access")
    json conn, %{"data" => %{"success" => true, "token" => new_token}}
  end
end
