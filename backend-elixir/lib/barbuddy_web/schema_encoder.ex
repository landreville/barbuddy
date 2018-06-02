defmodule BarBuddyWeb.SchemaEncoder do
  require Logger

  def encode(%{__struct__: _} = struct, options) do
    exclude_fields = if Keyword.has_key?(
                          struct.__struct__.__info__(:functions),
                          :exclude_fields
                        ) do
      struct.__struct__.exclude_fields
    else
      []
    end

    map = struct
          |> Map.from_struct
          |> sanitize_map(exclude_fields ++ unloaded_assocs(struct))
    Poison.Encoder.Map.encode(map, options)
  end

  defp sanitize_map(map, exclude) do
    Map.drop(map, [:__meta__, :__struct__] ++ exclude)
  end

  defp unloaded_assocs(struct) do
    struct.__struct__.__schema__(:associations)
    |> Enum.filter(&(!Ecto.assoc_loaded?(Map.get(struct, &1))))
  end
end
