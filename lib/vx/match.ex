defmodule Vx.Match do
  @moduledoc """
  The Match helper checks whether a value matches a pattern. As this relies on
  macros, you need to `require Vx.Match` before using it.
  """

  @enforce_keys [:matcher, :pattern]
  defstruct [:matcher, :pattern]

  @doc """
  Creates a new type that matches a pattern.

  ## Examples

      iex> require Vx.Match
      ...> schema = Vx.Match.t(%{a: _, b: _})
      ...> Vx.valid?(schema, %{a: 1, b: 2})
      true

      iex> require Vx.Match
      ...> schema = Vx.Match.t(%{a: _, b: _})
      ...> Vx.valid?(schema, %{a: 1, c: 2})
      false
  """
  @spec t(term) :: Macro.t()
  defmacro t(pattern) do
    pattern_as_str = Macro.to_string(pattern)

    quote do
      %unquote(__MODULE__){
        matcher: &match?(unquote(pattern), &1),
        pattern: unquote(pattern_as_str)
      }
    end
  end

  defimpl Vx.Validatable do
    def validate(%{matcher: matcher}, value), do: matcher.(value)
  end

  defimpl Vx.Humanizable do
    def humanize(%{pattern: pattern}), do: "match #{pattern}"
  end
end
