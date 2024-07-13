defmodule Vx.Validator do
  @moduledoc """
  The Validator type provides a function to validate a value with.
  """

  @enforce_keys [:fun]
  defstruct [:fun]

  @type fun :: (any -> Vx.Validatable.result())

  @type t :: %__MODULE__{fun: fun}

  @spec t(fun) :: Vx.t()
  def t(fun), do: %__MODULE__{fun: fun}

  defimpl Vx.Validatable do
    def validate(schema, value), do: schema.fun.(value)
  end
end
