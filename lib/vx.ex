defmodule Vx do
  alias Vx.Validatable

  @type t :: Validatable.t()

  @spec validate(Validatable.t(), any) ::
          :ok | {:error, Vx.TypeError.t()}
  def validate(type, value) do
    Validatable.validate(type, value)
  end

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

  @spec optional(Validatable.t()) :: Validatable.t()
  def optional(inner), do: Vx.Optional.t(inner)

  @spec is_not(Validatable.t()) :: Validatable.t()
  def is_not(inner), do: Vx.Not.t(inner)

  @spec intersect(nonempty_list(Validatable.t())) :: Validatable.t()
  def intersect(inner), do: Vx.Intersect.t(inner)

  @spec union(nonempty_list(Validatable.t())) :: Validatable.t()
  def union(inner), do: Vx.Union.t(inner)
end
