defmodule Vx.Tuple.Shape do
  @moduledoc """
  A constraint that verifies the shape of a tuple.
  """

  @enforce_keys [:shape]
  defstruct [:shape]

  @type t :: %__MODULE__{shape: tuple}

  defimpl Vx.Validatable do
    def validate(%{shape: shape}, value) do
      max_size = max(tuple_size(value), tuple_size(shape))

      0..(max_size - 1)
      |> Enum.flat_map(fn index ->
        with {:value_elem, {:ok, value}} <-
               {:value_elem, fetch_elem(value, index)},
             {:shape_elem, {:ok, shape}} <-
               {:shape_elem, fetch_elem(shape, index)},
             {:match, []} <- {:match, Vx.errors_on(shape, value)} do
          []
        else
          {:value_elem, :error} ->
            ["element at index #{index} is missing"]

          {:shape_elem, :error} ->
            ["element at index #{index} is abundant"]

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

    defp fetch_elem(tuple, index)
         when index >= 0 and index < tuple_size(tuple),
         do: {:ok, elem(tuple, index)}

    defp fetch_elem(_tuple, index) when index >= 0, do: :error
  end
end
