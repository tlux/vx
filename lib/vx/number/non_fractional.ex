defmodule Vx.Number.NonFractional do
  @moduledoc false

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

  defimpl Vx.Printable do
    def print(_), do: "non fractional"
  end
end
