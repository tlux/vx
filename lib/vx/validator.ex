defmodule Vx.Validator do
  @moduledoc """
  A struct that represents a validator.
  """

  alias Vx.ValidationError

  defstruct [:fun, :message, details: %{}]

  @type fun :: (any -> boolean | :ok | :error | {:error, Exception.t()})
  @type message :: String.t() | (any -> String.t())
  @type details :: %{optional(atom) => any}

  @type t :: %__MODULE__{
          fun: fun,
          details: details,
          message: message | nil
        }

  @doc """
  A validator that performs no validation at all.
  """
  @spec noop() :: t
  def noop, do: new(fn _ -> true end)

  @doc """
  Creates a new validator.
  """
  @spec new(fun, details, message | nil) :: t
  def new(fun, details \\ %{}, message \\ nil) do
    %__MODULE__{fun: fun, details: details, message: message}
  end

  @doc false
  @spec run(t, any) :: :ok | {:error, ValidationError.t()}
  def run(%__MODULE__{fun: fun} = validator, value) do
    case fun.(value) do
      true ->
        :ok

      :ok ->
        :ok

      {:error, error} ->
        {:error, ValidationError.new(validator, value, error)}

      _ ->
        {:error, ValidationError.new(validator, value)}
    end
  end
end
