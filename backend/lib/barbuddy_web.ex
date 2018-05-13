defimpl Poison.Encoder,
        for: [BarBuddyDB.Recipe, BarBuddyDB.Ingredient, BarBuddyDB.RecipeIngredient] do
  alias BarBuddyWeb.SchemaEncoder

  def encode(%{__struct__: _} = struct, options) do
    SchemaEncoder.encode(struct, options)
  end
end

defmodule BarBuddyWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use BarBuddyWeb, :controller
      use BarBuddyWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: BarBuddyWeb
      require Logger
      require Poison
      import Plug.Conn
      import BarBuddyWeb.Router.Helpers
      import BarBuddyWeb.Gettext
      import BarBuddyWeb.BaseController
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/barBuddy_web/templates",
                        namespace: BarBuddyWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import BarBuddyWeb.Router.Helpers
      import BarBuddyWeb.ErrorHelpers
      import BarBuddyWeb.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import BarBuddyWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
