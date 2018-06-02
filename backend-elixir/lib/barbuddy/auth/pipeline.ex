defmodule BarBuddy.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
      otp_app: :barbuddy,
      error_handler: BarBuddy.Auth.ErrorHandler,
      module: BarBuddy.Auth.Guardian


  plug Guardian.Plug.VerifyHeader, claims: %{
    "email_verified" => true,
    "aud" => "bar-buddy-46f19",
    "sign_in_provider" => "google.com",
    "iss" => "https://securetoken.google.com/bar-buddy-46f19"
  }
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end

