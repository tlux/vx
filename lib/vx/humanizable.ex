defprotocol Vx.Humanizable do
  @fallback_to_any true

  @spec humanize(t()) :: String.t()
  def humanize(schema)
end

defimpl Vx.Humanizable, for: Any do
  def humanize(schema) do
    inspect(schema)
  end
end
