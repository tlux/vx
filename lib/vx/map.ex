defmodule Vx.Map do
  @moduledoc """
  The Map type provides validators for maps.
  """

  use Vx.Type

  @doc """
  Checks whether a value is a map.
  """
  @spec t() :: t
  def t, do: init(&is_map/1)

  @doc """
  Checks whether a value is a map with the given key and value types.
  """
  @spec t(Vx.t(), Vx.t()) :: t
  def t(key_type, value_type) do
    init(
      &check_member_types(&1, key_type, value_type),
      %{key: key_type, value: value_type}
    )
  end

  defp check_member_types(map, key_type, value_type) when is_map(map) do
    Enum.reduce_while(map, :ok, fn {key, value}, _ ->
      with :ok <- Vx.Validatable.validate(key_type, key),
           :ok <- Vx.Validatable.validate(value_type, value) do
        {:cont, :ok}
      else
        error -> {:halt, error}
      end
    end)
  end

  defp check_member_types(_, _, _), do: :error

  @doc """
  Checks whether a value is a map partially matching the given key and value
  types. The map may contain additional items that remain unvalidated.

  ## Example

      iex> schema = Vx.Map.partial(%{foo: Vx.String.t(), bar: Vx.Integer.t()})
      ...> Vx.valid?(schema, %{foo: "hey!", bar: 123})
      true

      iex> schema = Vx.Map.partial(%{foo: Vx.String.t(), bar: Vx.Integer.t()})
      ...> Vx.valid?(schema, %{foo: "hey!", bar: 123, baz: "boom!"})
      true
  """
  @spec partial(t, %{optional(any) => Vx.t()}) :: t
  def partial(%__MODULE__{} = type \\ t(), shape) do
    add_validator(
      type,
      :partial,
      &check_partial(&1, shape),
      %{shape: shape, match_mode: :partial},
      "does not have the expected partial shape"
    )
  end

  defp check_partial(map, shape) do
    Enum.reduce_while(shape, :ok, fn
      {key, value_type}, _ ->
        with {:ok, key} <- resolve_key(map, key),
             {:ok, value} <- Map.fetch(map, key),
             :ok <- Vx.Validatable.validate(value_type, value) do
          {:cont, :ok}
        else
          :skip -> {:cont, :ok}
          error -> {:halt, error}
        end
    end)
  end

  defp resolve_key(map, %Vx.Optional{input: key}) do
    if Map.has_key?(map, key) do
      {:ok, key}
    else
      :skip
    end
  end

  defp resolve_key(_map, key), do: {:ok, key}

  @doc """
  Validation fails if the map contains other than the expected items.
  Checks whether a value is a map with exactly the given key and value types.

  ## Example

      iex> schema = Vx.Map.shape(%{foo: Vx.String.t(), bar: Vx.Integer.t()})
      ...> Vx.valid?(schema, %{foo: "hey!", bar: 123})
      true

      iex> schema = Vx.Map.shape(%{foo: Vx.String.t(), bar: Vx.Integer.t()})
      ...> Vx.valid?(schema, %{foo: "hey!", bar: "123"})
      false

      iex> schema = Vx.Map.shape(%{foo: Vx.String.t(), bar: Vx.Integer.t()})
      ...> Vx.valid?(schema, %{foo: "hey!"})
      false

      iex> schema = Vx.Map.shape(%{foo: Vx.String.t(), bar: Vx.Integer.t()})
      ...> Vx.valid?(schema, %{foo: "hey!", bar: 123, baz: "boom!"})
      false

      iex> schema = Vx.Map.shape(%{foo: Vx.String.t(), bar: Vx.Integer.t()})
      ...> Vx.valid?(schema, %{foo: "hey!", bar: 123, baz: "boom!"})
      false
  """
  @spec shape(t, %{optional(any) => Vx.t()}) :: t
  def shape(%__MODULE__{} = type \\ t(), shape) do
    add_validator(
      type,
      :shape,
      &check_shape(&1, shape),
      %{shape: shape, match_mode: :exact},
      "does not have the expected shape"
    )
  end

  defp check_shape(map, shape) do
    required_keys =
      shape
      |> Map.keys()
      |> Enum.reject(&optional_key?/1)
      |> MapSet.new()

    actual_keys = map |> Map.keys() |> MapSet.new()

    if MapSet.subset?(required_keys, actual_keys) do
      Enum.reduce_while(map, :ok, fn {key, value}, _ ->
        with {:ok, value_type} <- fetch_value_type(shape, key),
             :ok <- Vx.Validatable.validate(value_type, value) do
          {:cont, :ok}
        else
          error -> {:halt, error}
        end
      end)
    else
      :error
    end
  end

  defp optional_key?(%Vx.Optional{}), do: true
  defp optional_key?(_), do: false

  # finds a value type using the given key
  defp fetch_value_type(shape, key) do
    Enum.find_value(shape, :error, fn
      {%Vx.Optional{input: ^key}, value_type} -> {:ok, value_type}
      {^key, value_type} -> {:ok, value_type}
      _ -> nil
    end)
  end

  @doc """
  Checks whether a value is a map with the given size.
  """
  @spec size(t, non_neg_integer) :: t
  def size(%__MODULE__{} = type \\ t(), count)
      when is_integer(count) and count >= 0 do
    add_validator(
      type,
      :size,
      &(map_size(&1) == count),
      %{count: count},
      "does not have the expected size of #{count}"
    )
  end
end
