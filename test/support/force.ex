defmodule Vx.Force do
  @enforce_keys [:result]
  defstruct [:result]

  def force(result), do: %__MODULE__{result: result}

  defimpl Vx.Validatable do
    def validate(%{result: result}, _) do
      result
    end
  end
end
