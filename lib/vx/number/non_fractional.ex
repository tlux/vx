defmodule Vx.Number.NonFractional do
  @moduledoc """
  A constraint that verifies a number is not a fractional number.
  """

  defstruct []

  @type t :: %__MODULE__{}

  defimpl Vx.Validatable do
    def validate(_, value) do
      if trunc(value) == value do
        :ok
      else
        {:error, "must not be a fractional number"}
      end
    end
  end

  defimpl Vx.Humanizable do
    def humanize(_), do: "non fractional"
  end
end
