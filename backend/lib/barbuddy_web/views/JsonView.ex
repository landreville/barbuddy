defmodule BarBuddyWeb.JsonView do
  use BarBuddyWeb, :view
  alias BarBuddyDB.Recipe

  def render("data.json", %{data: data}) do
    %{"data" => data}
  end

  def render("success.json", %{success: success}) do
    %{"data" => %{"success" => success}}
  end

  def render("recipes.json", %{recipes: recipes}) do
    recipes
    |> Stream.map(&(Map.put(&1, "image_url", Recipe.image_url(&1))))
    |> (&(%{"data" => &1})).()
  end
end
