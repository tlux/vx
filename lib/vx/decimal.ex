if Code.ensure_loaded?(Decimal) do
  defmodule Vx.Decimal do
    @moduledoc """
    The Decimal type.
    """

    defstruct []

    @doc """
    Builds a new Decimal type.

    ## Examples

        iex> Vx.Decimal.t() |> Vx.valid?(Decimal.new("1.23"))
        true

        iex> Vx.Decimal.t() |> Vx.valid?("foo")
        false
    """
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
