defmodule Vx.Enum do
  @moduledoc """
  The Enum type.
  """

  @enforce_keys [:values]
  defstruct [:values]

  @type t :: %__MODULE__{values: nonempty_list}

  @doc """
  Builds a new Enum type.

  ## Examples

      iex> Vx.Enum.t([:foo, :bar]) |> Vx.valid?(:foo)
      true

      iex> Vx.Enum.t([:foo, :bar]) |> Vx.valid?(:baz)
      false
  """
  @spec t(nonempty_list) :: Vx.t()
  def t([_ | _] = values) when is_list(values) do
    %__MODULE__{values: values}
  end

  defimpl Vx.Validatable do
    def validate(%{values: values}, value), do: value in values
  end

  defimpl Vx.Printable do
    def print(%{values: values}) do
      "any of #{Vx.Util.inspect_enum(values)}"
    end
  end
end
