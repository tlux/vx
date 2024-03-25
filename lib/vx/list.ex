defmodule Vx.List do
  @moduledoc """
  The List type.
  """

  use Vx.Type, :list

  @doc """
  Builds a new List type.

  ## Examples

      iex> Vx.List.t() |> Vx.validate!([1, 2, 3])
      :ok

      iex> Vx.List.t() |> Vx.validate!("foo")
      ** (Vx.Error) must be a list
  """
  @spec t() :: t
  def t do
    new(fn
      value when is_list(value) -> :ok
      _ -> {:error, "must be a list"}
    end)
  end

  @doc """
  Builds a new List type with the given inner type.

  ## Examples

      iex> Vx.List.t(Vx.Number.t()) |> Vx.validate!([1, 2, 3])
      :ok

      iex> Vx.List.t(Vx.String.t()) |> Vx.validate!("foo")
      ** (Vx.Error) must be a list

      iex> Vx.List.t(Vx.String.t()) |> Vx.validate!(["foo", 2, "bar"])
      ** (Vx.Error) must be a list<string>
      - element 1: must be a string

  """
  @spec t(Vx.schema()) :: t
  def t(schema) do
    new([schema], &check_inner_schema(schema, &1))
  end

  defp check_inner_schema(schema, values) when is_list(values) do
    errors =
      values
      |> Enum.with_index()
      |> Enum.flat_map(fn {value, index} ->
        case Vx.Validatable.validate(schema, value) do
          :ok -> []
          {:error, message} -> ["- element #{index}: #{message}"]
        end
      end)

    if errors == [] do
      :ok
    else
      {:error,
       "must be a #{Vx.Inspectable.inspect(t(schema))}\n" <>
         Enum.join(errors, "\n")}
    end
  end

  defp check_inner_schema(_type, _values), do: {:error, "must be a list"}

  @doc """
  Requires the list to be non-empty.

  ## Examples

      iex> Vx.List.non_empty() |> Vx.validate!([1, 2, 3])
      :ok

      iex> Vx.List.non_empty() |> Vx.validate!([])
      ** (Vx.Error) must not be empty
  """
  @spec non_empty(t) :: t
  def non_empty(%__MODULE__{} = schema \\ t()) do
    constrain(schema, :non_empty, fn
      [] -> {:error, "must not be empty"}
      _ -> :ok
    end)
  end

  @spec size(t, non_neg_integer) :: t
  def size(%__MODULE__{} = schema \\ t(), size)
      when is_integer(size) and size >= 0 do
    constrain(schema, :size, size, fn value ->
      if length(value) == size do
        :ok
      else
        {:error, "must have a size of #{size}"}
      end
    end)
  end

  @doc """
  Requires the list to have a minimum size.
  """
  @spec min_size(t, non_neg_integer) :: t
  def min_size(%__MODULE__{} = schema \\ t(), size)
      when is_integer(size) and size >= 0 do
    constrain(schema, :min_size, size, fn value ->
      if length(value) >= size do
        :ok
      else
        {:error, "must have at least #{size} elements"}
      end
    end)
  end

  @doc """
  Requires the list to have a maximum size.
  """
  @spec max_size(t, non_neg_integer) :: t
  def max_size(%__MODULE__{} = schema \\ t(), size)
      when is_integer(size) and size >= 0 do
    constrain(schema, :max_size, size, fn value ->
      if length(value) <= size do
        :ok
      else
        {:error, "must have at most #{size} elements"}
      end
    end)
  end

  @doc """
  Requires the list to match the given shape.

  ## Examples

      iex> Vx.List.shape([Vx.Number.t(), Vx.String.t()]) |> Vx.validate!([123, "foo"])
      :ok

      iex> Vx.List.shape([Vx.Number.t(), Vx.String.t()]) |> Vx.validate!([123])
      ** (Vx.Error) must match [number, string]
      - element 1 is missing

      iex> Vx.List.shape([Vx.Number.t(), Vx.String.t()]) |> Vx.validate!([123, :foo])
      ** (Vx.Error) must match [number, string]
      - element 1: must be a string
  """
  @spec shape(t, [Vx.schema()]) :: t
  def shape(%__MODULE__{} = schema \\ t(), shape) when is_list(shape) do
    constrain(schema, :shape, shape, fn value ->
      value_size = length(value)
      shape_size = length(shape)
      max_size = max(value_size, shape_size)

      errors =
        Enum.flat_map(0..(max_size - 1), fn index ->
          with {:value_elem, {:ok, value}} <-
                 {:value_elem, fetch_elem(value, index, value_size)},
               {:shape_elem, {:ok, shape}} <-
                 {:shape_elem, fetch_elem(shape, index, shape_size)},
               {:match, :ok} <- {:match, Vx.Validatable.validate(shape, value)} do
            []
          else
            {:value_elem, :error} -> ["- element #{index} is missing"]
            {:shape_elem, :error} -> ["- element #{index} is abundant"]
            {:match, {:error, message}} -> ["- element #{index}: #{message}"]
          end
        end)

      if errors == [] do
        :ok
      else
        {:error,
         "must match #{Vx.Inspectable.inspect(shape)}\n" <>
           Enum.join(errors, "\n")}
      end
    end)
  end

  defp fetch_elem(list, index, actual_length)
       when index >= 0 and index < actual_length,
       do: {:ok, Enum.at(list, index)}

  defp fetch_elem(_list, index, _actual_length) when index >= 0, do: :error
end
