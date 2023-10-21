defmodule Vx.Any do
  use Vx.Type

  @spec t() :: t
  def t, do: init()

  @spec non_nil(t) :: t
  def non_nil(type \\ t()) do
    not_eq(type, nil)
  end

  @spec eq(t, any) :: t
  def eq(type \\ t(), value) do
    validate(type, :eq, &(&1 == value), %{value: value})
  end

  @spec not_eq(t, any) :: t
  def not_eq(type \\ t(), value) do
    validate(type, :not_eq, &(&1 != value), %{value: value})
  end

  @spec of(t, [any]) :: t
  def of(type \\ t(), members) when is_list(members) do
    validate(type, :of, &Enum.member?(members, &1), %{members: members})
  end

  @spec not_of(t, [any]) :: t
  def not_of(type \\ t(), values) when is_list(values) do
    validate(
      type,
      :not_of,
      fn value -> !Enum.member?(values, value) end,
      %{values: values}
    )
  end

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
