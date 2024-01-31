defprotocol Vx.Validatable2 do
  alias Vx.Validator

  # @fallback_to_any true

  @spec type(t) :: Validator.t()
  def type(term)

  @spec rules(t) :: [Validator.t()]
  def rules(term)
end

# defimpl Vx.Validatable2, for: Any do
#   def type(value), do: Vx.Validator.

#   def rules(_value), do: []
# end
