defmodule Vx.Struct do
  @moduledoc """
  The Struct type.
  """

  use Vx.Type, :struct

  @spec t() :: t
  def t do
    new(fn
      %_{} -> :ok
      _ -> {:error, "must be a struct"}
    end)
  end

  def t(struct) when is_atom(struct) do
    new([struct], fn
      %^struct{} -> :ok
      _ -> {:error, "must be a struct of type #{inspect(struct)}"}
    end)
  end
end
