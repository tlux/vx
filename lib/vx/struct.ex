defmodule Vx.Struct do
  @moduledoc """
  The Struct type provides validators for structs.
  """

  use Vx.Type

  @doc """
  Checks whether a value is a struct.
  """
  @spec t() :: t
  def t do
    new(
      fn
        %_{} -> true
        _ -> false
      end,
      %{},
      "must be a struct"
    )
  end

  @doc """
  Checks whether a value is a struct of the given type.
  """
  @spec t(module) :: t
  def t(struct) when is_atom(struct) do
    new(
      fn
        %^struct{} -> true
        _ -> false
      end,
      %{struct: struct},
      "must be a struct of type #{inspect(struct)}"
    )
  end
end
