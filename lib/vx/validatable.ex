defprotocol Vx.Validatable do
  @fallback_to_any true

  @spec validate(t, any) :: :ok | {:error, Vx.ValidationError.t()}
  def validate(validatable, value)
end

defimpl Vx.Validatable, for: Any do
  def validate(validatable, value) do
    validatable
    |> Vx.Any.eq()
    |> Vx.Validatable.validate(value)
  end
end
