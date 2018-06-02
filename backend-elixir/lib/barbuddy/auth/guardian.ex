defmodule BarBuddy.Auth.Guardian do
  use Guardian, otp_app: :barbuddy
  alias BarBuddy.Auth
  alias BarBuddyDB.AppUser
  require Logger

  def subject_for_token(resource, claims) do
    Logger.info "Resource: #{inspect resource}"
    Logger.info "Claims: #{inspect claims}"

    sub = to_string(resource.email)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    user = Auth.get_user claims["sub"]
    {:ok, user}
  end
end

