defmodule Vx.Util do
  @moduledoc false

  @spec inspect_enum(Enum.t(), (Enum.element() -> String.Chars.t())) ::
          String.t()
  def inspect_enum(enum, fun \\ &Kernel.inspect/1) do
    Enum.map_join(enum, ", ", fun)
  end
end
