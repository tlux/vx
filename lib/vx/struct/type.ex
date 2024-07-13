defmodule Vx.Struct.Type do
  @moduledoc """
  A constraint that verifies the type of a struct.
  """

  defstruct [:mod]

  @type t :: %__MODULE__{mod: module}

  defimpl Vx.Validatable do
    def validate(%{mod: mod}, value) do
      if is_struct(value, mod) do
        :ok
      else
        {:error, "is not a struct of type #{inspect(mod)}"}
      end
    end
  end
end
