defmodule Vx.Boolean do
  @moduledoc """
  The Boolean type.
  """

  use Vx.Type, :boolean

  @spec t() :: t
  def t do
    new(fn
      value when is_boolean(value) -> :ok
      _ -> {:error, "must be a boolean"}
    end)
  end
end
