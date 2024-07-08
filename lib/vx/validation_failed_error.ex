defmodule Vx.ValidationFailedError do
  defexception [:errors]

  @type t :: %__MODULE__{errors: [Vx.Error.t()]}

  @spec new([Vx.Error.t()]) :: t
  def new(errors) when is_list(errors) do
    %__MODULE__{errors: errors}
  end

  def message(%{errors: errors}) do
    "Validation failed:\n" <>
      Enum.map_join(errors, "\n", &"- #{Vx.Error.message(&1)}")
  end
end
