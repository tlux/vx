if Code.ensure_loaded?(Decimal) do
  defmodule Vx.Decimal do
    @moduledoc """
    The Decimal type.

    Note that you have to install the [`decimal`](https://hexdocs.pm/decimal)
    library as dependency to use this type.

    ## Comparisons

    As `Decimal` implements `compare/2` you can use the constraints from the
    `Vx.Comparable` module to make more sophisticated assertions.

        iex> Vx.Comparable.eq(Decimal.new("1.23"))
        ...> |> Vx.valid?(Decimal.new("1.23"))
        true

        iex> Vx.Decimal.t()
        ...> |> Vx.Comparable.eq(Decimal.new("1.23"))
        ...> |> Vx.valid?(Decimal.new("1.23"))
        true
    """
    @moduledoc since: "1.0.0"

    defstruct []

    @doc """
    Builds a new Decimal type.

    ## Examples

        iex> Vx.Decimal.t() |> Vx.valid?(Decimal.new("1.23"))
        true

        iex> Vx.Decimal.t() |> Vx.valid?("foo")
        false
    """
    @spec t() :: Vx.t()
    def t, do: %__MODULE__{}

    defimpl Vx.Validatable do
      def validate(_, %Decimal{}), do: true
      def validate(_, _), do: false
    end

    defimpl Vx.Humanizable do
      def humanize(_), do: "decimal"
    end
  end
end
