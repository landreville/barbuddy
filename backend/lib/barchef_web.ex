defimpl Poison.Encoder, for: Any do
  require Logger

  def encode(%{__struct__: _} = struct, options) do
    map = struct
          |> Map.from_struct
          |> sanitize_map(unloaded_assocs(struct))
    Poison.Encoder.Map.encode(map, options)
  end

  defp sanitize_map(map, unloaded_assocs) do
    Map.drop(map, [:__meta__, :__struct__] ++ unloaded_assocs)
  end

  defp unloaded_assocs(struct) do
    struct.__struct__.__schema__(:associations)
    |> Enum.filter(&(!Ecto.assoc_loaded?(Map.get(struct, &1))))
  end
end

defmodule BarchefWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use BarchefWeb, :controller
      use BarchefWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: BarchefWeb
      require Logger
      require Poison
      import Plug.Conn
      import BarchefWeb.Router.Helpers
      import BarchefWeb.Gettext
      import BarchefWeb.BaseController
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/barchef_web/templates",
                        namespace: BarchefWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import BarchefWeb.Router.Helpers
      import BarchefWeb.ErrorHelpers
      import BarchefWeb.Gettext
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
      import BarchefWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
