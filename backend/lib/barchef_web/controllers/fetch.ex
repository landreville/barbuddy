defmodule BarchefWeb.FetchMixin do
  alias BarChef.RecipeClient, as: RecipeClient
  defmacro __using__(_params) do
    quote do
      require Logger
      require HTTPoison

      def render_fetch(conn, path, params \\ [], data_fn \\ &(&1)) do
        case fetch(path, params) do
          {:ok, data} -> json conn, %{"data" => data_fn.(data)}
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
          %{"rows" => rows} -> {:ok, Enum.map(rows, &combine_id_value/1)}
          %{"error" => message, "reason" => reason} ->
            Logger.warn "Error from couchdb: " <> message <> ": " <> reason
            {:error, message <> ": " <> reason}
        end
      end

      defp combine_id_value(item) do
        case item do
          %{"id" => id, "key" => key, "value" => nested} ->
            Map.merge(%{"id" => id}, nested) |> Map.drop(["_id", "_rev"])
          %{"key" => key, "value" => true} -> key
        end
      end
    end
  end
end
