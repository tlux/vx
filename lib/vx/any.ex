defmodule Vx.Any do
  @moduledoc """
  The Any type provides validators for any type of value.
  """

  use Vx.Type

  @doc """
  Creates a no-op type.
  """
  @spec t() :: t
  def t, do: new()

  @doc """
  Checks whether a value is equal to the given value.
  """
  @spec eq(t, any) :: t
  def eq(type \\ t(), value) do
    add_rule(
      type,
      :eq,
      &(&1 == value),
      %{value: value},
      "must be equal to #{inspect(value)}"
    )
  end

  @doc """
  Checks whether a value is one of the given values.
  """
  @spec of(t, [any]) :: t
  def of(type \\ t(), values) do
    add_rule(
      type,
      :of,
      &Enum.member?(values, &1),
      %{values: values},
      fn _ ->
        "must be one of #{Enum.map_join(values, ", ", &inspect/1)}"
      end
    )
  end

  @doc """
  Checks whether a value matches the given pattern.
  """
  @spec match(any, any) :: Macro.t()
  defmacro match(type \\ quote(do: Vx.Any.t()), pattern) do
    pattern_as_str = Macro.to_string(pattern)

    quote do
      %{
        unquote(type)
        | __type__:
            Vx.Type.add_rule(
              unquote(type).__type__,
              :match,
              fn value ->
                match?(unquote(pattern), value)
              end,
              %{},
              fn _ ->
                "must match #{unquote(pattern_as_str)}"
              end
            )
      }
    end
  end
end
