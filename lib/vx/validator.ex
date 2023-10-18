defmodule Vx.Validator do
  alias Vx.TypeError

  defstruct [:schema_type, :validator_type, :fun]

  @type validator_type :: atom | {atom, any}
  @type fun :: (any -> boolean | :ok | :error | {:error, Exception.t()})
  @type t :: %__MODULE__{
          schema_type: atom,
          validator_type: validator_type | nil,
          fun: fun
        }

  @spec new(Vx.Schema.schema_type(), validator_type, fun) ::
          Vx.Validator.t()
  def new(schema_type, validator_type \\ nil, fun) when is_function(fun, 1) do
    %__MODULE__{
      schema_type: schema_type,
      validator_type: validator_type,
      fun: fun
    }
  end

  @spec eval(t, any) :: :ok | {:error, TypeError.t()}
  def eval(
        %__MODULE__{
          schema_type: schema_type,
          validator_type: validator_type,
          fun: fun
        },
        value
      ) do
    case fun.(value) do
      true ->
        :ok

      :ok ->
        :ok

      {:error, error} ->
        {:error, TypeError.new(schema_type, validator_type, value, error)}

      _ ->
        {:error, TypeError.new(schema_type, validator_type, value)}
    end
  end
end
