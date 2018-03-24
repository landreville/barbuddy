defmodule BarchefWeb.FetchMixin do
  alias BarChef.RecipeClient, as: RecipeClient
  defmacro __using__(_params) do
    quote do
      require Logger
      require HTTPoison

      def render_fetch(conn, path) do
        case fetch(path) do
          {:ok, data} -> json conn, %{"data" => data}
          {:error, message} ->
            Logger.warn "Error: " <> message
            conn |> put_status(500)
        end
      end

      def fetch(path, params \\ []) do
        resp = RecipeClient.get path, [], params: params
        case resp do
          {:error, %HTTPoison.Error{:reason => error_message}} ->
            Logger.warn "Error retrieving recipes: " <> error_message
            {:error, error_message}
          {:ok, %HTTPoison.Response{:body => body}} ->
            process_body(body)
        end
      end

      def process_body(body) do
        {:ok, data} = body
        case data do
          %{"rows" => rows} -> {:ok, rows}
          %{"error" => message, "reason" => reason} ->
            Logger.warn "Error from couchdb: " <> message <> ": " <> reason
            {:error, message <> ": " <> reason}
        end
      end
    end
  end
end
