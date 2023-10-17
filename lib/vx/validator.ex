defmodule Vx.Validator do
  alias Vx.TypeError

  defstruct [:schema_type, :key, :fun]

  @type fun :: (any -> boolean | :ok | :error | {:error, Exception.t()})
  @type t :: %__MODULE__{schema_type: atom, key: atom | nil, fun: fun}

  def new(schema_type, key \\ nil, fun) when is_function(fun, 1) do
    %__MODULE__{schema_type: schema_type, key: key, fun: fun}
  end

  @spec eval(t, any) :: :ok | {:error, TypeError.t()}
  def eval(%__MODULE__{schema_type: schema_type, key: key, fun: fun}, value) do
    case fun.(value) do
      true ->
        :ok

      :ok ->
        :ok

      {:error, error} ->
        {:error, TypeError.new(schema_type, key, value, error)}

      _ ->
        {:error, TypeError.new(schema_type, key, value)}
    end
  end
end
