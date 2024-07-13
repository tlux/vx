defmodule Vx.Validator do
  @moduledoc """
  The Validator type provides a function to validate a value with.
  """

  @enforce_keys [:fun]
  defstruct [:fun]

  @type fun :: boolean | :ok | :error | {:error, String.t()}

  @type t :: %__MODULE__{fun: fun}

  @spec t(fun) :: Vx.t()
  def t(fun), do: %__MODULE__{fun: fun}

  defimpl Vx.Validatable do
    def validate(schema, value) do
      case schema.fun.(value) do
        :ok -> :ok
        true -> :ok
        {:error, error} -> {:error, error}
        _ -> {:error, "is invalid"}
      end
    end
  end

  defimpl Vx.Humanizable do
    def humanize(_), do: "custom validator"
  end
end
