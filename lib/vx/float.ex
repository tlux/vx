defmodule Vx.Float do
  @moduledoc """
  The Float type provides validators for floats.
  """

  use Vx.Type, :float

  @spec t() :: t
  def t do
    new(fn
      value when is_float(value) -> :ok
      _ -> {:error, "must be a float"}
    end)
  end

  @spec integer(t) :: t
  def integer(%__MODULE__{} = type \\ t()) do
    Vx.Number.integer(type)
  end
end
