defmodule Vx.List.Shape do
  @moduledoc """
  A constraint that verifies the shape of a list.
  """

  @enforce_keys [:shape]
  defstruct [:shape]

  @type t :: %__MODULE__{shape: list}

  defimpl Vx.Validatable do
    def validate(%{shape: shape}, value) do
      value_size = length(value)
      shape_size = length(shape)
      max_size = max(value_size, shape_size)

      0..(max_size - 1)
      |> Enum.flat_map(fn index ->
        with {:value_elem, {:ok, value}} <-
               {:value_elem, fetch_elem(value, index, value_size)},
             {:shape_elem, {:ok, shape}} <-
               {:shape_elem, fetch_elem(shape, index, shape_size)},
             {:match, []} <- {:match, Vx.errors_on(shape, value)} do
          []
        else
          {:value_elem, :error} ->
            {:error, "element at index #{index} is missing"}

          {:shape_elem, :error} ->
            {:error, "element at index #{index} is abundant"}

          {:match, errors} ->
            Enum.map(errors, fn error ->
              error
              |> Vx.Error.prepend_path(index)
              |> Vx.Error.prepend_message("element at index #{index}")
            end)
        end
      end)
      |> then(fn
        [] -> :ok
        errors -> {:error, errors}
      end)
    end

    defp fetch_elem(list, index, actual_length)
         when index >= 0 and index < actual_length,
         do: {:ok, Enum.at(list, index)}

    defp fetch_elem(_list, index, _actual_length) when index >= 0, do: :error
  end
end
