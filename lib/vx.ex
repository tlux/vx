defmodule Vx do
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
    case validate(type, value) do
      :ok -> true
      _ -> false
    end
  end

  @doc """
  Marks the given type or field optional.
  """
  @spec optional(t) :: t
  def optional(type), do: Vx.Optional.t(type)

  @doc """
  Inverts the given type
  """
  @spec is_not(t) :: Vx.Not.t()
  def is_not(type), do: Vx.Not.t(type)

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
