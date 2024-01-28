defprotocol Vx.Validatable do
  @moduledoc """
  The Validatable protocol must be implemented by all types validatable by Vx.
  """

  @doc """
  Validates whether a value matches agianst the given type or schema.
  """
  @spec validate(t, any) :: :ok | {:error, Vx.ValidationError.t()}
  def validate(input, value)
end
