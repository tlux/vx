defimpl Vx.Printable,
  for: [Vx.List.Length, Vx.Map.Size, Vx.String.Length, Vx.Tuple.Size] do
  def print(schema) do
    schema
    |> Map.from_struct()
    |> Enum.map(fn {key, value} -> text(key, value) end)
    |> Enum.reject(&is_nil/1)
    |> Enum.join(", ")
  end

  defp text(_, nil), do: nil
  defp text(:is, value), do: "size = #{value}"
  defp text(:min, value), do: "size >= #{value}"
  defp text(:max, value), do: "size <= #{value}"
end
