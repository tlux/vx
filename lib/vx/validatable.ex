defprotocol Vx.Validatable do
  @moduledoc """
  The Validatable protocol that is implemented by all types of the Vx type
  system. As a fallback, any value not having an implementation for the
  `Vx.Validatable` protocol is considered a literal by Vx when passed to
  `validate/2`.
  """

  @fallback_to_any true

  @doc """
  Validates a value against a given validatable.
  """
  @spec validate(t, any) :: :ok | {:error, String.t()}
  def validate(validatable, value)
end

# Types that do not implement Vx.Validatable are considered literals
defimpl Vx.Validatable, for: Any do
  def validate(validatable, value) do
    validatable
    |> Vx.Literal.t()
    |> Vx.Validatable.validate(value)
  end
end
