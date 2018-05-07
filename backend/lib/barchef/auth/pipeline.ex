defmodule Barchef.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
      otp_app: :barchef,
      error_handler: Barchef.Auth.ErrorHandler,
      module: Barchef.Auth.Guardian

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end
