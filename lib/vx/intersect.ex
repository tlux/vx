defmodule Vx.Intersect do
  @moduledoc """
  The Intersect type combines multiple types into a single type, validating
  whether all of them are valid.
  """

  @enforce_keys [:of]
  defstruct [:of]

  @doc """
  Builds a new Intersect type.

  ## Examples

      iex> Vx.Intersect.t([Vx.Integer.t(), Vx.Number.t()]) |> Vx.validate!(123)
      :ok

      iex> Vx.Intersect.t([Vx.Integer.t(), Vx.Number.t()]) |> Vx.validate!(12.3)
      ** (Vx.Error) must be all of (integer & number)
  """
  @spec t(nonempty_list(Vx.t())) :: Vx.t()
  def t([_ | _] = of), do: %__MODULE__{of: of}

  defimpl Vx.Validatable do
    def validate(%{of: [of]}, value) do
      Vx.Validatable.validate(of, value)
    end

    def validate(%{of: of}, value) do
      Enum.flat_map(of, &Vx.Validatable.validate(&1, value))
    end
  end
end
