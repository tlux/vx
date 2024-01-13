defmodule Vx.Any do
  @moduledoc """
  The Any type provides validators for any type of value.
  """

  use Vx.Type

  @doc """
  A no-op validator.
  """
  @spec t() :: t
  def t, do: init()

  @doc false
  @spec eq(Vx.t(), any) :: t
  def eq(type \\ t(), value) do
    validate(type, :eq, &(&1 == value), %{value: value})
  end

  @doc false
  @spec of(Vx.t(), [any]) :: t
  def of(type \\ t(), values) when is_list(values) do
    validate(type, :of, &Enum.member?(values, &1), %{values: values})
  end

  @doc """
  Checks whether a value matches the given pattern.
  """
  @spec match(any, any) :: Macro.t()
  defmacro match(type \\ quote(do: Vx.Any.t()), pattern) do
    quote do
      %{
        unquote(type)
        | validators:
            Vx.Validators.add(unquote(type).validators, :match, fn value ->
              match?(unquote(pattern), value)
            end)
      }
    end
  end
end
