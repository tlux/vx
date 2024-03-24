defmodule Vx.Literal do
  @moduledoc """
  The Literal type.
  """

  @enforce_keys [:value]
  defstruct [:value]

  @type t :: t(any)
  @opaque t(value) :: %__MODULE__{value: value}

  @doc """
  Builds a new Literal type from a value.

  ## Examples

      iex> Vx.Literal.t(:foo) |> Vx.validate!(:foo)
      :ok

      iex> Vx.Literal.t(:foo) |> Vx.validate!(:bar)
      ** (Vx.Error) must be :foo

  Note that everything not being a type (to be precise anything not implementing
  the `Vx.Validatable` protocol) is automatically considered a literal. So this
  is equivalent to the previous example:

      iex> :foo |> Vx.validate!(:foo)
      :ok

      iex> :foo |> Vx.validate!(:bar)
      ** (Vx.Error) must be :foo
  """
  @spec t(value) :: t(value) when value: var
  def t(value) do
    %__MODULE__{value: value}
  end

  defimpl Vx.Validatable do
    def validate(%{value: value}, actual_value) do
      if value == actual_value do
        :ok
      else
        {:error, "must be #{Kernel.inspect(value)}"}
      end
    end
  end

  defimpl Vx.Inspectable do
    def inspect(%{value: value}), do: Kernel.inspect(value)
  end
end
