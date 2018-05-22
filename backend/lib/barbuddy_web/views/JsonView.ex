defmodule BarBuddyWeb.JsonView do
  use BarBuddyWeb, :view

  def render("data.json", %{data: data}) do
    %{"data" => data}
  end

  def render("success.json", %{success: success}) do
    %{"data" => %{"success" => success}}
  end

  def render("recipes.json", %{recipes: recipes}) do
    %{"data" => recipes}
  end
end
