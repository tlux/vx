defmodule Vx do
  @moduledoc """
  Vx is an extensible schema validation library for Elixir.
  """

  alias Vx.Validatable

  @type t :: Validatable.t()

  @doc """
  Validates whether the given value matches the given type.
  """
  @spec validate(t, any) :: :ok | {:error, Vx.ValidationError.t()}
  def validate(validatable, value) do
    Validatable.validate(validatable, value)
  end

  @doc """
  Validates whether the given value matches the given type. Raises on error.
  """
  @spec validate!(t, any) :: :ok | no_return
  def validate!(validatable, value) do
    with {:error, error} <- validate(validatable, value) do
      raise error
    end
  end

  @doc """
  Validates the schema and returns a boolean.
  """
  @spec valid?(t, any) :: boolean
  def valid?(type, value) do
    match?(:ok, validate(type, value))
  end

  @doc """
  Marks the given type or field optional.
  """
  @spec optional(t) :: t
  def optional(type), do: Vx.Optional.t(type)

  @doc """
  Inverts the given type
  """
  @spec non(t) :: Vx.Not.t()
  def non(type), do: Vx.Not.t(type)

  @doc """
  Marks the given type or field as nullable.
  """
  @spec null() :: t
  def null, do: eq(nil)

  @doc """
  Marks the given type or field as non-nullable.
  """
  @spec non_null() :: t
  def non_null, do: non(null())

  @doc """
  Checks whether a value is equal to the given value.
  """
  @spec eq(t, any) :: t
  def eq(type \\ Vx.Any.t(), value) do
    Vx.Type.add_validator(type, :eq, &(&1 == value), %{value: value})
  end

  @doc """
  Checks whether a value is one of the given values.
  """
  @spec of([any]) :: t
  def of(type \\ Vx.Any.t(), values) do
    Vx.Type.add_validator(
      type,
      :of,
      &Enum.member?(values, &1),
      %{values: values}
    )
  end

  @doc """
  Checks whether a value matches the given pattern.
  """
  @spec match(any, any) :: Macro.t()
  defmacro match(type \\ quote(do: Vx.Any.t()), pattern) do
    quote do
      Vx.Type.add_validator(unquote(type), :match, fn value ->
        match?(unquote(pattern), value)
      end)
    end
  end

  @doc """
  Intersects the given types.
  """
  @spec intersect(nonempty_list(t)) :: Vx.Intersect.t()
  def intersect(types), do: Vx.Intersect.t(types)

  @doc """
  Unions the given types.
  """
  @spec union(nonempty_list(t)) :: Vx.Union.t()
  def union(types), do: Vx.Union.t(types)
end
