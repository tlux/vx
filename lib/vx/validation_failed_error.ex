defmodule Vx.ValidationFailedError do
  @enforce_keys [:errors]
  defexception [:errors]

  @type t :: %__MODULE__{errors: [Vx.Error.t()]}

  @spec new(nonempty_list(Vx.Error.t())) :: t
  def new([_ | _] = errors) when is_list(errors) do
    %__MODULE__{errors: errors}
  end

  @impl true
  def message(%{errors: errors}) do
    "Validation failed: " <> Enum.map_join(errors, ", ", &Vx.Error.message/1)
  end
end
