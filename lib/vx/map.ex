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
  Checks whether a value is a map with the given key and value types.
  """
  @spec shape(t, %{optional(any) => Vx.t()}) :: t
  def shape(%__MODULE__{} = type \\ t(), shape) do
    validate(
      type,
      :shape,
      &check_map_shape(&1, shape),
      %{shape: shape}
    )
  end

  defp check_map_shape(map, shape) do
    Enum.reduce_while(shape, :ok, fn
      {key, type}, _ ->
        with {:ok, key} <- resolve_key(map, key),
             {:ok, value} <- Map.fetch(map, key),
             :ok <- Vx.Validatable.validate(type, value) do
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
  Checks whether a value is a map with the given size.
  """
  @spec size(t, non_neg_integer) :: t
  def size(%__MODULE__{} = type \\ t(), count)
      when is_integer(count) and count >= 0 do
    validate(type, :size, &(map_size(&1) == count), %{count: count})
  end
end
