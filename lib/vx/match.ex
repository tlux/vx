defmodule Vx.Match do
  @moduledoc """
  The Match helper checks whether a value matches a pattern. As this relies on
  macros, you need to `require Vx.Match` before using it.
  """

  @doc """
  Creates a new type that matches a pattern.

  ## Examples

      iex> require Vx.Match
      ...> schema = Vx.Match.t(%{a: _, b: _})
      ...> Vx.validate!(schema, %{a: 1, b: 2})
      :ok

      iex> require Vx.Match
      ...> schema = Vx.Match.t(%{a: _, b: _})
      ...> Vx.validate!(schema, %{a: 1, c: 2})
      ** (Vx.Error) must match %{a: _, b: _}
  """
  @spec t(term) :: Macro.t()
  defmacro t(pattern) do
    pattern_as_str = Macro.to_string(pattern)

    quote do
      Vx.Type.new(:match, fn value ->
        if match?(unquote(pattern), value) do
          :ok
        else
          {:error, "must match #{unquote(pattern_as_str)}"}
        end
      end)
    end
  end
end
