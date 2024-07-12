defmodule Vx.Intersect do
  @moduledoc """
  The Intersect type combines multiple types into a single type, validating
  whether all of them are valid.
  """

  @enforce_keys [:mp, :md]
  defstruct [:mp, :md]

  @doc """
  Builds a new Intersect type.

  ## Examples

      iex> Vx.Intersect.t(Vx.Integer.t(), Vx.Number.t()) |> Vx.valid?(123)
      true

      iex> Vx.Intersect.t(Vx.Integer.t(), Vx.Number.t()) |> Vx.valid?(12.3)
      false
  """
  @spec t(Vx.t(), Vx.t()) :: Vx.t()
  def t(mp, md) do
    %__MODULE__{mp: mp, md: md}
  end

  @spec t(nonempty_list(Vx.t())) :: Vx.t()
  def t([_ | _] = list) when is_list(list) do
    Enum.reduce(list, fn item, acc ->
      t(acc, item)
    end)
  end

  defimpl Vx.Validatable do
    def validate(%{mp: mp, md: md}, value) do
      Vx.Validatable.validate(mp, value) ++
        Vx.Validatable.validate(md, value)
    end
  end
end
