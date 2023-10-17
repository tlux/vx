defmodule Vx.Validator do
  defstruct [:key, :fun]

  @type fun :: (any -> boolean)
  @type t :: %__MODULE__{key: atom | nil, fun: fun}

  def new(key \\ nil, fun) when is_function(fun, 1) do
    %__MODULE__{key: key, fun: fun}
  end

  def eval(%__MODULE__{key: key, fun: fun}, value) do
    case fun.(value) do
      true -> :ok
      false -> {:error, key}
    end
  end
end
