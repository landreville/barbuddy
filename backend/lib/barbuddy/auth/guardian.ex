defmodule BarBuddy.Auth.Guardian do
  use Guardian, otp_app: :barbuddy
  alias BarBuddy.Auth

  def subject_for_token(resource, _claims) do
    sub = to_string(resource.email)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    user = Auth.get_user claims["sub"]
    {:ok, user}
  end
end

