defmodule Vx.Tuple do
  use Vx.Type, :tuple

  @spec t() :: t
  def t do
    new(fn
      value when is_tuple(value) -> :ok
      _ -> {:error, "must be a tuple"}
    end)
  end

  @spec size(t, non_neg_integer) :: t
  def size(%__MODULE__{} = type \\ t(), size)
      when is_integer(size) and size > 0 do
    constrain(type, :size, size, fn value ->
      if tuple_size(value) == size do
        :ok
      else
        {:error, "must have size of #{size}"}
      end
    end)
  end

  @spec shape(t, tuple) :: t
  def shape(%__MODULE__{} = type \\ t(), shape) when is_tuple(shape) do
    constrain(type, :shape, shape, fn value ->
      max_size = max(tuple_size(value), tuple_size(shape))

      errors =
        Enum.flat_map(0..(max_size - 1), fn index ->
          with {:value_elem, {:ok, value}} <-
                 {:value_elem, fetch_elem(value, index)},
               {:shape_elem, {:ok, shape}} <-
                 {:shape_elem, fetch_elem(shape, index)},
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

  defp fetch_elem(tuple, index)
       when index >= 0 and index < tuple_size(tuple),
       do: {:ok, elem(tuple, index)}

  defp fetch_elem(_tuple, index) when index >= 0, do: :error
end
