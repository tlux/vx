defmodule Vx.Struct do
  use Vx.Type

  @spec t() :: t
  def t do
    init(fn
      %_{} -> true
      _ -> false
    end)
  end

  @spec t(struct | module) :: t
  def t(struct) when is_atom(struct) do
    init(
      fn
        %^struct{} -> true
        _ -> false
      end,
      %{struct: struct}
    )
  end

  def t(%struct{}), do: t(struct)
end
