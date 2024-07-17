defmodule Vx.Comparable.Between do
  @moduledoc false

  @enforce_keys [:comparable, :first, :last]
  defstruct [:comparable, :first, :last]

  @type t :: %__MODULE__{comparable: module, first: number, last: number}

  defimpl Vx.Validatable do
    def validate(
          %{comparable: comparable, first: first, last: last},
          actual_value
        ) do
      if comparable.compare(actual_value, first) in [:gt, :eq] &&
           comparable.compare(actual_value, last) in [:lt, :eq] do
        :ok
      else
        {:error, "must be between #{first} and #{last}"}
      end
    end
  end

  defimpl Vx.Printable do
    def print(%{first: first, last: last}) do
      "between #{first} and #{last}"
    end
  end
end
