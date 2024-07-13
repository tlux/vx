defimpl Vx.Humanizable, for: [Vx.List.Length, Vx.Map.Size, Vx.Tuple.Size] do
  def humanize(schema) do
    schema
    |> Map.from_struct()
    |> Enum.map(fn {key, value} -> text(key, value) end)
    |> Enum.reject(&is_nil/1)
    |> Enum.join(", ")
  end

  defp text(_, nil), do: nil
  defp text(:is, value), do: "size of #{value}"
  defp text(:min, value), do: "min size of #{value}"
  defp text(:max, value), do: "max size of #{value}"
end
