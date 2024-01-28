defprotocol Vx.Validatable do
  @moduledoc """
  The Validatable protocol must be implemented by all types validatable by Vx.
  """

  @fallback_to_any true

  @doc """
  Validates whether a value matches agianst the given type or schema.
  """
  @spec validate(t, any) :: :ok | {:error, Vx.ValidationError.t()}
  def validate(input, value)
end

# Any type not implementing the protocol will be treated as a literal
defimpl Vx.Validatable, for: Any do
  def validate(input, value) do
    input
    |> Vx.eq()
    |> Vx.Validatable.validate(value)
  end
end
