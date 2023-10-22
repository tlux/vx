defprotocol Vx.Validatable do
  @fallback_to_any true

  @spec validate(t, any) :: :ok | {:error, Vx.TypeError.t()}
  def validate(type, value)
end

defimpl Vx.Validatable, for: Any do
  def validate(type, value) do
    type
    |> Vx.Any.eq()
    |> Vx.Validatable.validate(value)
  end
end
