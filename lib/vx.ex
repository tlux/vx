defmodule Vx do
  alias Vx.Validatable

  @spec validate(Validatable.t(), any) ::
          :ok | {:error, Vx.TypeError.t()}
  def validate(type_or_value, value) do
    Validatable.validate(type_or_value, value)
  end

  @spec validate!(Validatable.t(), any) :: :ok | no_return
  def validate!(type_or_value, value) do
    with {:error, error} <- validate(type_or_value, value) do
      raise error
    end
  end

  @doc """
  Validates the schema and returns a boolean.
  """
  @spec valid?(Validatable.t(), any) :: boolean
  def valid?(type_or_value, value) do
    case validate(type_or_value, value) do
      :ok -> true
      _ -> false
    end
  end

  @spec optional(Validatable.t()) :: Validatable.t()
  def optional(inner), do: Vx.Optional.t(inner)

  @spec is_not(Validatable.t()) :: Validatable.t()
  def is_not(inner), do: Vx.Not.t(inner)

  @spec intersect(nonempty_list(Validatable.t())) :: Validatable.t()
  def intersect(inner), do: Vx.Intersect.t(inner)

  @spec union(nonempty_list(Validatable.t())) :: Validatable.t()
  def union(inner), do: Vx.Union.t(inner)
end
