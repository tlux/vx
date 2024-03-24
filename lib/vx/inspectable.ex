defprotocol Vx.Inspectable do
  @moduledoc """
  The Inspectable protocol allows converting types to a string representation.
  """

  @fallback_to_any true

  @spec inspect(t) :: String.t()
  def inspect(inspectable)
end

defimpl Vx.Inspectable, for: Any do
  defdelegate inspect(inspectable), to: Kernel
end

defimpl Vx.Inspectable, for: List do
  def inspect(list) do
    "[" <> Vx.Util.inspect_enum(list, &Vx.Inspectable.inspect/1) <> "]"
  end
end

defimpl Vx.Inspectable, for: Map do
  def inspect(map) do
    "%{" <>
      Vx.Util.inspect_enum(map, fn {key, value} ->
        "#{Vx.Inspectable.inspect(key)} => #{Vx.Inspectable.inspect(value)}"
      end) <> "}"
  end
end

defimpl Vx.Inspectable, for: Tuple do
  def inspect(tuple) do
    inner =
      tuple
      |> Tuple.to_list()
      |> Vx.Util.inspect_enum(&Vx.Inspectable.inspect/1)

    "{#{inner}}"
  end
end
