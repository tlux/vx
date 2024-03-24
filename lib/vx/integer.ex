defmodule Vx.Integer do
  @moduledoc """
  The Integer type.
  """

  use Vx.Type, :integer

  @spec t() :: t
  def t do
    new(fn
      value when is_integer(value) -> :ok
      _ -> {:error, "must be an integer"}
    end)
  end
end
