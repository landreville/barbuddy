defmodule BarBuddy.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
      otp_app: :barbuddy,
      error_handler: BarBuddy.Auth.ErrorHandler,
      module: BarBuddy.Auth.Guardian

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access", "admin" => true}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
