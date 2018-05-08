defmodule Barchef.Auth.Auth do
  alias BarchefDB.AppUser
  alias Barchef.Auth.Guardian
  alias Barchef.Repo
  alias Comeonin.Bcrypt
  import Ecto.Query
  require Logger


  def authenticate_user(email, plaintext_password) do
    query = from u in AppUser, where: u.email == ^email
    Repo.one(query)
    |> check_password(plaintext_password)
  end

  def token_from_user(user) do
    claims = if user.admin do
      %{"admin" => true}
    else
      %{}
    end

    case Guardian.encode_and_sign(user, claims, ttl: {7, :day}) do
      {:ok, token, _} -> {:ok, token}
      {:error, reason} -> {:error, reason}
    end
  end

  def refresh_token(token) do
    case Guardian.refresh(token, ttl: {7, :day}) do
      {:ok, _, {new_token, _}} -> {:ok, new_token}
      {:error, reason} -> {:error, reason}
    end
  end

  def get_user(email) do
    query = from u in AppUser, where: u.email == ^email
    Repo.one(query)
  end

  defp check_password(nil, _), do: {:error, "Incorrect username or password"}

  defp check_password(user, plaintext_password) do
    case Bcrypt.checkpw(plaintext_password, user.password) do
      true -> {:ok, user}
      false -> {:error, "Incorrect username or password"}
    end
  end

end
