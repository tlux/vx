defmodule Vx.Map do
  @moduledoc """
  The Map type.
  """

  use Vx.Type, :map

  import Vx.Util

  @doc """
  Builds a new Map type that matches any map.

  ## Examples

      iex> Vx.Map.t() |> Vx.validate!(%{})
      :ok

      iex> Vx.Map.t() |> Vx.validate!(%{a: "foo", b: 123})
      :ok

      iex> Vx.Map.t() |> Vx.validate!("foo")
      ** (Vx.Error) must be a map
  """
  @spec t() :: t
  def t do
    new(fn
      value when is_map(value) -> :ok
      _ -> {:error, "must be a map"}
    end)
  end

  @doc """
  Builds a new Map type with a specific key and value type.

  ## Examples

      iex> Vx.Map.t(Vx.String.t(), Vx.Number.t()) |> Vx.validate!(%{})
      :ok

      iex> schema = Vx.Map.t(Vx.Atom.t(), Vx.Number.t())
      ...> Vx.validate!(schema, %{a: 123, b: 234.5})
      :ok

      iex> Vx.Map.t(Vx.Atom.t(), Vx.Number.t()) |> Vx.validate!("foo")
      ** (Vx.Error) must be a map<atom, number>

      iex> Vx.Map.t(Vx.Atom.t(), Vx.Number.t()) |> Vx.validate!(%{foo: "bar"})
      ** (Vx.Error) must be a map<atom, number>
      - value of element :foo: must be a number
  """
  @spec t(Vx.t(), Vx.t()) :: t
  def t(key_t, value_t) do
    new([key_t, value_t], &check_map_of(&1, key_t, value_t))
  end

  defp check_map_of(map, key_t, value_t) when is_map(map) do
    errors =
      Enum.flat_map(map, fn {key, value} ->
        with {:key, :ok} <- {:key, Vx.Validatable.validate(key_t, key)},
             {:value, :ok} <- {:value, Vx.Validatable.validate(value_t, value)} do
          []
        else
          {:key, {:error, message}} ->
            ["- element #{inspect(key)}: #{message}"]

          {:value, {:error, message}} ->
            ["- value of element #{inspect(key)}: #{message}"]
        end
      end)

    if errors == [] do
      :ok
    else
      {:error,
       error_msg(key_t, value_t) <>
         "\n" <>
         Enum.join(errors, "\n")}
    end
  end

  defp check_map_of(_map, key_t, value_t) do
    {:error, error_msg(key_t, value_t)}
  end

  defp error_msg(key_t, value_t) do
    "must be a #{Vx.Inspectable.inspect(t(key_t, value_t))}"
  end

  @doc """
  Checks the size of the map.

  ## Examples

      iex> Vx.Map.size(0) |> Vx.validate!(%{})
      :ok

      iex> Vx.Map.size(1) |> Vx.validate!(%{a: "foo", b: 123})
      ** (Vx.Error) must have a size of 1
  """
  @spec size(t, non_neg_integer) :: t
  def size(%__MODULE__{} = type \\ t(), size)
      when is_integer(size) and size >= 0 do
    constrain(type, :size, size, fn value ->
      if map_size(value) == size do
        :ok
      else
        {:error, "must have a size of #{size}"}
      end
    end)
  end

  @doc """
  Checks the shape of the map.

  ## Examples

      iex> schema = Vx.Map.shape(%{a: Vx.String.t(), b: Vx.Number.t()})
      ...> Vx.validate!(schema, %{a: "foo", b: 123})
      :ok

      iex> schema = Vx.Map.shape(%{a: Vx.String.t(), b: Vx.Number.t()})
      ...> Vx.validate!(schema, %{a: "foo"})
      ** (Vx.Error) must have key(s) :b

      iex> schema = Vx.Map.shape(%{a: Vx.String.t(), b: Vx.Number.t()})
      ...> Vx.validate!(schema, %{a: "foo", b: "bar"})
      ** (Vx.Error) does not match shape
      - key :b: must be a number

  It is also possible to mark certain keys as optional.

      iex> schema = Vx.Map.shape(%{
      ...>   :a => Vx.String.t(),
      ...>   Vx.Optional.t(:b) => Vx.Number.t()
      ...> })
      ...> Vx.validate!(schema, %{a: "foo"})
      :ok

      iex> schema = Vx.Map.shape(%{
      ...>   a: Vx.String.t(),
      ...>   b: Vx.Optional.t(Vx.Number.t())
      ...> })
      ...> Vx.validate!(schema, %{a: "foo"})
      :ok

      iex> schema = Vx.Map.shape(%{
      ...>   :a => Vx.String.t(),
      ...>   Vx.Optional.t(:b) => Vx.Number.t()
      ...> })
      ...> Vx.validate!(schema, %{a: "foo", b: "bar"})
      ** (Vx.Error) does not match shape
      - key :b: must be a number
  """
  @spec shape(t, map) :: t
  def shape(%__MODULE__{} = type \\ t(), shape) when is_map(shape) do
    constrain(type, :shape, shape, &check_shape(&1, shape))
  end

  defp check_shape(map, shape) do
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
        {:error, "must not have key(s) #{inspect_enum(excess_keys)}"}

      MapSet.size(missing_keys) > 0 ->
        {:error, "must have key(s) #{inspect_enum(missing_keys)}"}

      true ->
        errors =
          Enum.flat_map(shape, fn {key, value_t} ->
            with {:ok, value} <- fetch_value(map, key, value_t),
                 :ok <- Vx.Validatable.validate(value_t, value) do
              []
            else
              :omit ->
                []

              {:error, message} ->
                ["- key #{inspect(resolve_key(key))}: #{message}"]
            end
          end)

        if errors == [] do
          :ok
        else
          {:error, "does not match shape\n" <> Enum.join(errors, "\n")}
        end
    end
  end

  defp fetch_value(map, %Vx.Optional{of: key}, _value_t) do
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

  defp extract_keys(shape) do
    Enum.reduce(shape, {MapSet.new(), MapSet.new()}, fn
      {%Vx.Optional{of: key}, _}, {required, optional} ->
        {required, MapSet.put(optional, key)}

      {key, %Vx.Optional{}}, {required, optional} ->
        {required, MapSet.put(optional, key)}

      {key, _}, {required, optional} ->
        {MapSet.put(required, key), optional}
    end)
  end

  defp resolve_key(%Vx.Optional{of: key}), do: key
  defp resolve_key(key), do: key
end
