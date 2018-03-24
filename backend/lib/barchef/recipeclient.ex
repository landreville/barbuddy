defmodule BarChef.RecipeClient do
  use HTTPoison.Base
  require Logger

  @base_url "http://172.17.0.2:5984/peacock"
  @design_url "http://172.17.0.2:5984/peacock/_design/peacock/_view/"

  def process_url(url) do
    case String.slice(url, 0..0) do
      "/" -> @base_url <> url
      _ -> @design_url <> url
    end
  end

  def process_response_body(body) do
    body |> Jason.decode
  end


end
