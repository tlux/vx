defprotocol Vx.Validatable2 do
  # @spec validate_type(t, any) :: :ok | {:error, ValidationError.t()}
  # def validate_type(type, value)

  # @spec validate_rules(t, any) :: :ok | {:error, [Vx.ValidationError.t()]}
  # def validate_rules(type, value)

  @fallback_to_any true

  @spec type(t) :: Validator.t() | nil
  def type(type)

  @spec rules(t) :: [Validator.t()]
  def rules(type)
end

defimpl Vx.Validatable2, for: Any do
  def type(value), do: Vx.eq(value)

  def rules(_value), do: []
end
