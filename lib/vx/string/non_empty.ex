defmodule Vx.String.NonEmpty do
  @moduledoc """
  A constraint that verifies a string is not empty.
  """

  defstruct []

  @type t :: %__MODULE__{}

  defimpl Vx.Validatable do
    def validate(_, value) do
      if value == "" do
        {:error, "must not be empty"}
      else
        :ok
      end
    end
  end
end
