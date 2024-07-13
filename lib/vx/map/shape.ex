defmodule Vx.Map.Shape do
  @moduledoc """
  A constraint that verifies the shape of a map.
  """

  @enforce_keys [:shape]
  defstruct [:shape]

  @type t :: %__MODULE__{shape: map}

  defimpl Vx.Validatable do
    import Vx.Util, only: [inspect_enum: 1]

    def validate(%{shape: shape}, map) do
      {required_keys, optional_keys} = extract_keys(shape)
      all_keys = MapSet.union(required_keys, optional_keys)
      ambiguous_keys = MapSet.intersection(required_keys, optional_keys)

      if MapSet.size(ambiguous_keys) > 0 do
        raise ArgumentError,
              "key(s) #{inspect_enum(ambiguous_keys)} " <>
                "must not be defined as required and optional at the same time"
      end

      actual_keys = MapSet.new(map, fn {key, _} -> key end)
      missing_keys = MapSet.difference(required_keys, actual_keys)
      excess_keys = MapSet.difference(actual_keys, all_keys)

      cond do
        MapSet.size(excess_keys) > 0 ->
          {:error, ["must not have key(s) #{inspect_enum(excess_keys)}"]}

        MapSet.size(missing_keys) > 0 ->
          {:error, ["must have key(s) #{inspect_enum(missing_keys)}"]}

        true ->
          validate_members(map, shape)
      end
    end

    defp validate_members(map, shape) do
      shape
      |> Enum.flat_map(fn {key, value_schema} ->
        with {:ok, value} <- fetch_value(map, key, value_schema),
             {:validate, []} <-
               {:validate, Vx.errors_on(value_schema, value)} do
          []
        else
          :omit ->
            []

          {:validate, errors} ->
            key = resolve_key(key)
            Enum.map(errors, &Vx.Error.prepend_path(&1, key))
        end
      end)
      |> then(fn
        [] -> :ok
        errors -> {:error, errors}
      end)
    end

    defp extract_keys(shape) do
      Enum.reduce(shape, {MapSet.new(), MapSet.new()}, fn
        {%Vx.Optional{schema: key}, _}, {required, optional} ->
          {required, MapSet.put(optional, key)}

        {key, %Vx.Optional{}}, {required, optional} ->
          {required, MapSet.put(optional, key)}

        {key, _}, {required, optional} ->
          {MapSet.put(required, key), optional}
      end)
    end

    defp fetch_value(map, %Vx.Optional{schema: key}, _value_t) do
      case Map.fetch(map, key) do
        {:ok, value} -> {:ok, value}
        :error -> :omit
      end
    end

    defp fetch_value(map, key, %Vx.Optional{}) do
      case Map.fetch(map, key) do
        {:ok, nil} -> :omit
        {:ok, value} -> {:ok, value}
        :error -> :omit
      end
    end

    defp fetch_value(map, key, _value_t) do
      # should never raise as key existence is already validated at this point
      {:ok, Map.fetch!(map, key)}
    end

    defp resolve_key(%Vx.Optional{schema: key}), do: key
    defp resolve_key(key), do: key
  end

  defimpl Vx.Humanizable do
    def humanize(%{shape: shape}) do
      Enum.map_join(shape, ", ", fn {key, value} ->
        "#{inspect(key)} => #{Vx.Humanizable.humanize(value)}"
      end)
    end
  end
end
