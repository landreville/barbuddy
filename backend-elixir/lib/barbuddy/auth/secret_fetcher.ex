defmodule BarBuddy.Auth.SecretFetcher do
  alias HTTPoison
  require Logger
  alias JOSE.JWK
  use Guardian.Token.Jwt.SecretFetcher
  alias Guardian.Token.Jwt.SecretFetcher.SecretFetcherDefaultImpl

  def fetch_signing_secret(mod, opts) do
    SecretFetcherDefaultImpl.fetch_signing_secret(mod, opts)
  end

  def fetch_verifying_secret(mod, headers, opts) do
    IO.puts "Secret Fetcher"
    # TODO: Use the value of max-age in the Cache-Control to cache keys response
    public_keys_url = "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com"
    keys_resp = HTTPoison.get! public_keys_url
    key_map = JWK.from_firebase(keys_resp.body)
    %{"kid" => key_id} = headers
    {:ok, key_map[key_id]}
  end
end
