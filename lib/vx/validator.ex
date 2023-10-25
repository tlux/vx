defmodule Vx.Validator do
  alias Vx.ValidationError

  defstruct [:type, :name, :fun, :message, details: %{}]

  @type name :: atom

  @type details :: %{optional(atom) => any}

  @type fun :: (any -> boolean | :ok | :error | {:error, Exception.t()})

  @type t :: %__MODULE__{
          type: module,
          name: name | nil,
          fun: fun,
          details: details,
          message: String.t() | nil
        }

  @doc false
  @spec new(module, name | nil, fun, details, String.t() | nil) ::
          Vx.Validator.t()
  def new(type, name, fun, details, message)
      when is_function(fun, 1) and is_map(details) do
    %__MODULE__{
      type: type,
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
