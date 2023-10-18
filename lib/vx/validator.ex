defmodule Vx.Validator do
  alias Vx.ValidationError

  defstruct [:schema_name, :name, :fun, details: %{}]

  @type name :: atom
  @type details :: %{optional(atom) => any}
  @type fun :: (any -> boolean | :ok | :error | {:error, Exception.t()})

  @type t :: %__MODULE__{
          schema_name: atom,
          name: name,
          fun: fun,
          details: details
        }

  @doc false
  @spec new(
          Vx.Schema.name(),
          name,
          fun,
          details
        ) :: Vx.Validator.t()
  def new(schema_name, name, fun, details)
      when is_atom(schema_name) and
             is_atom(name) and
             is_function(fun, 1) and
             is_map(details) do
    %__MODULE__{
      schema_name: schema_name,
      name: name,
      fun: fun,
      details: details
    }
  end

  @doc false
  @spec eval(t, any) :: :ok | {:error, ValidationError.t()}
  def eval(%__MODULE__{fun: fun} = validator, value) do
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
