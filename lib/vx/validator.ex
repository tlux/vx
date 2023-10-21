defmodule Vx.Validator do
  alias Vx.TypeError

  defstruct [:type, :name, :fun, details: %{}]

  @type name :: atom
  @type details :: %{optional(atom) => any}
  @type fun :: (any -> boolean | :ok | :error | {:error, Exception.t()})

  @type t :: %__MODULE__{
          type: module,
          name: name | nil,
          fun: fun,
          details: details
        }

  @doc false
  @spec new(module, name | nil, fun, details) :: Vx.Validator.t()
  def new(type, name, fun, details)
      when is_function(fun, 1) and is_map(details) do
    %__MODULE__{type: type, name: name, fun: fun, details: details}
  end

  @doc false
  @spec run(t, any) :: :ok | {:error, TypeError.t()}
  def run(%__MODULE__{fun: fun} = validator, value) do
    case fun.(value) do
      true ->
        :ok

      :ok ->
        :ok

      {:error, error} ->
        {:error, TypeError.new(validator, value, error)}

      _ ->
        {:error, TypeError.new(validator, value)}
    end
  end
end
