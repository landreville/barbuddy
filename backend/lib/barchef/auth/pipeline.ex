defmodule Barchef.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
      otp_app: :barchef,
      error_handler: Barchef.Auth.ErrorHandler,
      module: Barchef.Auth.Guardian

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access", "admin" => true}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
