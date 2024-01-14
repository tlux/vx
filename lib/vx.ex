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
  @spec eq(any) :: t
  defdelegate eq(value), to: Vx.Any

  @doc """
  Checks whether a value is equal to the given value.
  """
  @spec eq(t, any) :: t
  defdelegate eq(type, value), to: Vx.Any

  @doc """
  Checks whether a value is one of the given values.
  """
  @spec of([any]) :: t
  defdelegate of(value), to: Vx.Any

  @doc """
  Checks whether a value is one of the given values.
  """
  @spec of(t, [any]) :: t
  defdelegate of(type, value), to: Vx.Any

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
