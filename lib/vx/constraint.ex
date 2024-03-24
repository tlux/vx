defmodule Vx.Constraint do
  @moduledoc """
  A constraint for a `Vx.Type`. You can add a constraint to a type using
  `Vx.Type.constrain/3` and `Vx.Type.constrain/4`.
  """

  @derive {Inspect, only: [:name, :value], optional: [:value]}
  @enforce_keys [:name, :fun]
  defstruct [:name, :value, :fun]

  @type fun :: (any -> :ok | {:error, String.t()})

  @type t :: %__MODULE__{name: atom, value: any, fun: fun}

  @doc false
  @spec new(any, any, fun) :: t
  def new(name, value \\ nil, fun) when is_function(fun, 1) do
    %__MODULE__{name: name, value: value, fun: fun}
  end

  @doc false
  @spec validate(t, any) :: :ok | {:error, String.t()}
  def validate(%__MODULE__{fun: fun}, value) do
    fun.(value)
  end

  @doc false
  @spec to_string(t) :: String.t()
  def to_string(%__MODULE__{name: name, value: nil}), do: Kernel.to_string(name)

  def to_string(%__MODULE__{name: name, value: value}) do
    "#{name}=#{Vx.Inspectable.inspect(value)}"
  end
end
