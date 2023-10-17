defprotocol Vx.Castable do
  @spec cast(t, any) :: {:ok, any} | {:error, any}
  def cast(schema, value)
end
