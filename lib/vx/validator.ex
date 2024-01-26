defmodule Vx.Validator do
  @moduledoc """
  A struct that represents a validator.
  """

  alias Vx.ValidationError

  defstruct [:module, :name, :fun, :message, details: %{}]

  @type name :: atom

  @type details :: %{optional(atom) => any}

  @type fun :: (any -> boolean | :ok | :error | {:error, Exception.t()})

  @type message :: String.t() | (any -> String.t())

  @type t :: %__MODULE__{
          module: module,
          name: name | nil,
          fun: fun,
          details: details,
          message: message | nil
        }

  @doc false
  @spec new(module, name | nil, fun, details, message | nil) ::
          Vx.Validator.t()
  def new(module, name, fun, details, message)
      when is_function(fun, 1) and is_map(details) do
    %__MODULE__{
      module: module,
      name: name,
      fun: fun,
      details: details,
      message: message
    }
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
