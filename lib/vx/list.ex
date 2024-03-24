defmodule Vx.List do
  @moduledoc """
  The List type provides validators for lists.
  """

  use Vx.Type, :list

  @spec t() :: t
  def t do
    new(fn
      value when is_list(value) -> :ok
      _ -> {:error, "must be a list"}
    end)
  end

  def t(type) do
    new([type], &check_inner_type(type, &1))
  end

  defp check_inner_type(type, values) when is_list(values) do
    errors =
      values
      |> Enum.with_index()
      |> Enum.flat_map(fn {value, index} ->
        case Vx.Validatable.validate(type, value) do
          :ok -> []
          {:error, message} -> ["- element #{index}: #{message}"]
        end
      end)

    if errors == [] do
      :ok
    else
      {:error,
       "must be a #{Vx.Inspectable.inspect(t(type))}\n" <>
         Enum.join(errors, "\n")}
    end
  end

  defp check_inner_type(_type, _values), do: {:error, "must be a list"}

  @spec non_empty(t) :: t
  def non_empty(%__MODULE__{} = type \\ t()) do
    constrain(type, :non_empty, fn
      [] -> {:error, "must not be empty"}
      _ -> :ok
    end)
  end

  @spec size(t, non_neg_integer) :: t
  def size(%__MODULE__{} = type \\ t(), size)
      when is_integer(size) and size >= 0 do
    constrain(type, :size, size, fn value ->
      if length(value) == size do
        :ok
      else
        {:error, "must have size of #{size}"}
      end
    end)
  end

  @spec min_size(t, non_neg_integer) :: t
  def min_size(%__MODULE__{} = type \\ t(), size)
      when is_integer(size) and size >= 0 do
    constrain(type, :min_size, size, fn value ->
      if length(value) >= size do
        :ok
      else
        {:error, "must have at least #{size} elements"}
      end
    end)
  end

  @spec max_size(t, non_neg_integer) :: t
  def max_size(%__MODULE__{} = type \\ t(), size)
      when is_integer(size) and size >= 0 do
    constrain(type, :max_size, size, fn value ->
      if length(value) <= size do
        :ok
      else
        {:error, "must have at most #{size} elements"}
      end
    end)
  end

  @spec shape(t, [Vx.t()]) :: t
  def shape(%__MODULE__{} = type \\ t(), shape) when is_list(shape) do
    constrain(type, :shape, shape, fn value ->
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
