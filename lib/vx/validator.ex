defmodule Vx.Validator do
  @moduledoc """
  The Validator type provides a function to validate a value with.
  """

  @enforce_keys [:fun]
  defstruct [:fun]

  @type result :: boolean | :ok | :error | {:error, String.t()}

  @type fun :: (any -> result)

  @type t :: %__MODULE__{fun: fun}

  @doc """
  Creates a new validator from a function.
  """
  @spec t(fun) :: Vx.t()
  def t(fun) when is_function(fun, 1) do
    %__MODULE__{fun: fun}
  end

  @doc """
  Creates a new validator from a function and adds it as constraint to the
  given schema.
  """
  @doc since: "1.0.0"
  @spec t(Vx.t(), fun) :: Vx.t()
  def t(schema, fun) when is_function(fun, 1) do
    Vx.Constrained.t(schema, t(fun))
  end

  defimpl Vx.Validatable do
    def validate(%{fun: fun}, value) do
      case fun.(value) do
        :ok -> :ok
        true -> :ok
        {:error, error} -> {:error, error}
        _ -> {:error, "is invalid"}
      end
    end
  end

  defimpl Vx.Printable do
    def print(_), do: "(custom validator)"
  end
end
