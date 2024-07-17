defmodule Vx.SizePrinter do
  @moduledoc false

  def print(prop, schema) do
    schema
    |> Map.from_struct()
    |> Enum.map(fn {key, value} -> text(prop, key, value) end)
    |> Enum.reject(&is_nil/1)
    |> Enum.join(", ")
  end

  defp text(_, _, nil), do: nil
  defp text(prop, :is, value), do: "#{prop} = #{value}"
  defp text(prop, :min, value), do: "#{prop} >= #{value}"
  defp text(prop, :max, value), do: "#{prop} <= #{value}"
end

defimpl Vx.Printable, for: [Vx.List.Length, Vx.String.Length] do
  def print(schema), do: Vx.SizePrinter.print("length", schema)
end

defimpl Vx.Printable, for: [Vx.Map.Size, Vx.Tuple.Size] do
  def print(schema), do: Vx.SizePrinter.print("size", schema)
end
