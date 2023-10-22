defmodule Vx do
  alias Vx.Validatable

  @doc """
  Validates whether the given value matches the given type.
  """
  @spec validate(Validatable.t(), any) ::
          :ok | {:error, Vx.TypeError.t()}
  def validate(type, value) do
    Validatable.validate(type, value)
  end

  @doc """
  Validates whether the given value matches the given type. Raises on error.
  """
  @spec validate!(Validatable.t(), any) :: :ok | no_return
  def validate!(type, value) do
    with {:error, error} <- validate(type, value) do
      raise error
    end
  end

  @doc """
  Validates the schema and returns a boolean.
  """
  @spec valid?(Validatable.t(), any) :: boolean
  def valid?(type, value) do
    case validate(type, value) do
      :ok -> true
      _ -> false
    end
  end

  @doc """
  Marks the given type or field optional.
  """
  @spec optional(Validatable.t()) :: Validatable.t()
  def optional(type), do: Vx.Optional.t(type)

  @doc """
  Inverts the given type
  """
  @spec is_not(Validatable.t()) :: Validatable.t()
  def is_not(type), do: Vx.Not.t(type)

  @doc """
  Intersects the given types.
  """
  @spec intersect(nonempty_list(Validatable.t())) :: Validatable.t()
  def intersect(types), do: Vx.Intersect.t(types)

  @doc """
  Unions the given types.
  """
  @spec union(nonempty_list(Validatable.t())) :: Validatable.t()
  def union(types), do: Vx.Union.t(types)
end
