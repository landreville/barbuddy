defmodule BarChef.RecipeClient do
  use HTTPoison.Base
  require Logger

  @base_url "http://172.17.0.2:5984/peacock/_design/peacock/_view/"

  def process_url(url) do
    Logger.debug "Fetching URL: " <> @base_url <> url
    @base_url <> url
  end

  def process_response_body(body) do
    body |> Jason.decode
  end


end
