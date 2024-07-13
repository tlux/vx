defmodule Vx.String.Present do
  @moduledoc """
  A constraint that verifies a string is present.
  """

  defstruct []

  @type t :: %__MODULE__{}

  defimpl Vx.Validatable do
    def validate(_, value) do
      if String.trim(value) == "" do
        {:error, "must be present"}
      else
        :ok
      end
    end
  end
end
