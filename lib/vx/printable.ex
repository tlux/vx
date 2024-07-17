defprotocol Vx.Printable do
  @moduledoc """
  A protocol to convert a schema into a human-readable representation.
  """
  @moduledoc since: "1.0.0"

  @fallback_to_any true

  @spec print(t()) :: String.t()
  def print(schema)
end

defimpl Vx.Printable, for: Any do
  def print(schema) do
    inspect(schema)
  end
end
