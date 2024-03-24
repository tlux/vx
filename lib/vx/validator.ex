defmodule Vx.Validator do
  @moduledoc """
  A type that can be used to validate values using a custom function.
  """

  @enforce_keys [:fun]
  defstruct [:fun]

  @type fun :: (any -> boolean | :ok | :error | {:error, String.t()})

  @type t :: %__MODULE__{fun: fun}

  @spec t(fun) :: t
  def t(fun) when is_function(fun, 1) do
    %__MODULE__{fun: fun}
  end

  defimpl Vx.Validatable do
    def validate(%{fun: fun}, value) do
      case fun.(value) do
        true -> :ok
        :ok -> :ok
        {:error, message} -> {:error, message}
        _ -> {:error, "is invalid"}
      end
    end
  end

  defimpl Vx.Inspectable do
    def inspect(_), do: "(custom validator)"
  end
end
