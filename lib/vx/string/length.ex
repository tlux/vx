defmodule Vx.String.Length do
  @moduledoc """
  A constraint that verifies the length of a string.
  """

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
      actual = String.length(value)

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
      "does not have a length of #{expected}"
    end

    defp error_message_for(:min, expected) do
      "must have at least #{expected} characters"
    end

    defp error_message_for(:max, expected) do
      "must have at most #{expected} characters"
    end
  end
end
