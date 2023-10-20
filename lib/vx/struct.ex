defmodule Vx.Struct do
  alias Vx.Schema

  @type t :: Schema.t(:struct)

  @spec t() :: t
  def t do
    Schema.new(:struct, fn
      %_{} -> true
      _ -> false
    end)
  end

  @spec t(struct | module) :: t
  def t(struct) when is_atom(struct) do
    Schema.new(
      :struct,
      fn
        %^struct{} -> true
        _ -> false
      end,
      %{struct: struct}
    )
  end

  def t(%struct{}), do: t(struct)
end
