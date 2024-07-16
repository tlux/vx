defmodule Vx.Tuple.Size do
  @moduledoc false

  @derive {Inspect, optional: [:is, :min, :max]}
  defstruct [:is, :min, :max]

  @type t :: %__MODULE__{
          is: nil | non_neg_integer,
          min: nil | non_neg_integer,
          max: nil | non_neg_integer
        }

  @doc false
  @spec new(Keyword.t()) :: t
  def new(opts) do
    struct!(__MODULE__, opts)
  end

  defimpl Vx.Validatable do
    def validate(schema, value) do
      actual = tuple_size(value)

      schema
      |> Map.from_struct()
      |> Enum.flat_map(fn {key, expected} ->
        if valid_value?(key, actual, expected) do
          []
        else
          [error_message_for(key, expected)]
        end
      end)
      |> then(fn
        [] -> :ok
        errors -> {:error, errors}
      end)
    end

    defp valid_value?(_, _, nil), do: true
    defp valid_value?(:is, actual, expected), do: actual == expected
    defp valid_value?(:min, actual, expected), do: actual >= expected
    defp valid_value?(:max, actual, expected), do: actual <= expected

    defp error_message_for(:is, expected) do
      "does not have a size of #{expected}"
    end

    defp error_message_for(:min, expected) do
      "does not have a minimal size of #{expected}"
    end

    defp error_message_for(:max, expected) do
      "exceeds the maximal size of #{expected}"
    end
  end
end
