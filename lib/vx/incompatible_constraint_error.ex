defmodule Vx.IncompatibleConstraintError do
  @moduledoc """
  An error that is raised when a constraint cannot be applied to a type due to
  compatibility restrictions.
  """

  @enforce_keys [:constraint, :permitted, :actual]
  defexception [:constraint, :permitted, :actual]

  @type t :: %__MODULE__{
          constraint: Vx.t(),
          permitted: [Vx.t()],
          actual: Vx.t()
        }

  @impl true
  def message(%{constraint: constraint, permitted: permitted, actual: actual}) do
    "unable to add constraint #{inspect(constraint)} to #{inspect(actual)}" <>
      " (must be one of #{Vx.Util.inspect_enum(permitted)})"
  end
end
