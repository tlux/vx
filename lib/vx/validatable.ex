defprotocol Vx.Validatable do
  @moduledoc """
  The Validatable protocol that is implemented by all types of the `Vx` type
  system.

  As a fallback, any value not having an implementation for the `Vx.Validatable`
  protocol is considered a `Vx.Literal` when passed to `validate/2`.
  """

  @fallback_to_any true

  @doc """
  Validates a value against a given validatable.
  """
  @spec validate(t, any) :: [Vx.Error.t()]
  def validate(validatable, value)
end

defimpl Vx.Validatable, for: Any do
  def validate(literal, value) do
    literal
    |> Vx.Literal.t()
    |> Vx.Validatable.validate(value)
  end
end
