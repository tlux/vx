defmodule Vx.IncompatibleConstraintError do
  defexception [:constraint, :permitted, :actual]

  def message(%{constraint: constraint, permitted: permitted, actual: actual}) do
    "unable to add constraint #{inspect(constraint)} to #{inspect(actual)}" <>
      " (must be one of #{Vx.Util.inspect_enum(permitted)})"
  end
end
