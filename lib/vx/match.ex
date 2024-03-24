defmodule Vx.Match do
  @moduledoc """
  The Match type provides validators for matching a pattern. As this relies on
  macros, you need to `require Vx.Match` before using.
  """

  @doc """
  Creates a new type that matches a pattern.
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
