defmodule BarBuddyWeb.BaseController do
  import Phoenix.Controller
  require Logger

  def changeset_render(conn, changeset, action) do
    case action.(changeset) do
      {:ok, _record} -> json conn, %{"data" => %{"success" => true}}
      {:error, cs} ->
        Logger.warn "Errors inserting/updating. " <>
                    "Action: #{inspect action}. Errors: #{inspect cs.errors}"
        errors = change_errors_to_map(cs)
        json conn, %{"data" => %{"success" => false, "error" => errors}}
    end
    render conn, "success.json", success: false
  end

  defp change_errors_to_map(%Ecto.Changeset{:errors => errors}) do
    errors
    |> Enum.map(fn({field, {message, _error_list}}) -> {field, message} end)
    |> Map.new
  end
end
