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

  @doc """
  Checks whether a value is nil.
  """
  @spec is_nil(Vx.t()) :: t
  def is_nil(type \\ t()) do
    eq(type, nil)
  end

  @doc """
  Checks whether a value is not nil.
  """
  @spec non_nil(Vx.t()) :: t
  def non_nil(type \\ t()) do
    not_eq(type, nil)
  end

  @doc """
  Checks whether a value is equal to the given value.
  """
  @spec eq(Vx.t(), any) :: t
  def eq(type \\ t(), value) do
    validate(type, :eq, &(&1 == value), %{value: value})
  end

  @doc """
  Checks whether a value is not equal to the given value.
  """
  @spec not_eq(Vx.t(), any) :: t
  def not_eq(type \\ t(), value) do
    validate(type, :not_eq, &(&1 != value), %{value: value})
  end

  @doc """
  Checks whether a value is one of the given values.
  """
  @spec of(Vx.t(), [any]) :: t
  def of(type \\ t(), values) when is_list(values) do
    validate(type, :of, &Enum.member?(values, &1), %{values: values})
  end

  @doc """
  Checks whether a value is not one of the given values.
  """
  @spec not_of(Vx.t(), [any]) :: t
  def not_of(type \\ t(), values) when is_list(values) do
    validate(
      type,
      :not_of,
      fn value -> !Enum.member?(values, value) end,
      %{values: values}
    )
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
