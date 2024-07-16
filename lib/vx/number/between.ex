defmodule Vx.Number.Between do
  @moduledoc false

  @enforce_keys [:first, :last]
  defstruct [:first, :last]

  @type t :: %__MODULE__{first: number, last: number}

  defimpl Vx.Validatable do
    def validate(%{first: first, last: last}, value) do
      if first <= value && value <= last do
        :ok
      else
        {:error, "must be between #{first} and #{last}"}
      end
    end
  end

  defimpl Vx.Humanizable do
    def humanize(%{first: first, last: last}) do
      "between #{first} and #{last}"
    end
  end
end
