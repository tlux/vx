defmodule Vx.Except do
  @moduledoc """
  The Except type btracts one type from another.
  """

  @enforce_keys [:a, :b]
  defstruct [:a, :b]

  @doc """
  Builds a new Except type.
  """
  @spec t(Vx.t(), Vx.t()) :: Vx.t()
  def t(a, b), do: %__MODULE__{a: a, b: b}

  @spec t(nonempty_list(Vx.t())) :: Vx.t()
  def t([_, _ | _] = list) when is_list(list) do
    Enum.reduce(list, &t(&2, &1))
  end

  defimpl Vx.Validatable do
    def validate(%{a: a, b: b}, value) do
      Vx.valid?(a, value) && !Vx.valid?(b, value)
    end
  end

  defimpl Vx.Humanizable do
    def humanize(%{a: a, b: b}) do
      "#{Vx.Humanizable.humanize(a)} except #{Vx.Humanizable.humanize(b)}"
    end
  end
end
