defmodule Vx.List do
  alias Vx.Schema

  @type t :: Schema.t(:list)

  @spec t() :: t
  def t, do: Schema.new(:list, &is_list/1)

  @spec t(Schema.t() | [Schema.t()]) :: t
  def t(element_schema_or_schemata)

  def t(element_schemata) when is_list(element_schemata) do
    element_schemata
    |> Schema.union()
    |> t()
  end

  def t(%Schema{} = element_schema) do
    Schema.new(
      :list,
      &validate_values(&1, element_schema),
      %{of: element_schema}
    )
  end

  defp validate_values(values, element_schema) do
    Enum.reduce_while(values, :ok, fn value, _ ->
      case Schema.eval(element_schema, value) do
        :ok -> {:cont, :ok}
        {:error, error} -> {:halt, error}
      end
    end)
  end

  @spec non_empty(t) :: t
  def non_empty(%Schema{name: :list} = schema \\ t()) do
    Schema.validate(schema, :non_empty, fn
      [] -> false
      _ -> true
    end)
  end

  @spec size(t, non_neg_integer) :: t
  def size(%Schema{name: :list} = schema \\ t(), count)
      when is_integer(count) and count >= 0 do
    Schema.validate(
      schema,
      :size,
      fn list -> length(list) == count end,
      %{count: count}
    )
  end

  @spec shape(t, [Schema.t() | any]) :: t
  def shape(%Schema{name: :list} = schema \\ t(), structure)
      when is_list(structure) do
    expected_size = length(structure)

    Schema.validate(
      schema,
      :shape,
      &check_list_shape(&1, structure, expected_size),
      %{structure: structure}
    )
  end

  defp check_list_shape(list, structure, expected_size)
       when length(list) == expected_size do
    structure
    |> Enum.with_index()
    |> Enum.reduce_while(:ok, fn {schema_or_value, index}, _ ->
      value = Enum.at(list, index)

      case Schema.eval(schema_or_value, value) do
        :ok -> {:cont, :ok}
        error -> {:halt, error}
      end
    end)
  end

  defp check_list_shape(_, _, _), do: :error
end
