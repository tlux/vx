defprotocol Vx.Validatable do
  @fallback_to_any true

  @spec validate(t, any) :: :ok | {:error, Vx.TypeError.t()}
  def validate(type, value)
end

defimpl Vx.Validatable, for: Any do
  def validate(type_or_value, value) do
    type_or_value
    |> Vx.Any.eq()
    |> Vx.Validatable.validate(value)
  end
end
