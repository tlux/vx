defmodule Vx.Tuple do
  alias Vx.Schema

  @type t :: Schema.t(:tuple)

  @spec t() :: t
  def t, do: Schema.new(:tuple, &is_tuple/1)

  @spec size(t, non_neg_integer) :: t
  def size(%Schema{name: :tuple} = schema \\ t(), count)
      when is_integer(count) and count >= 0 do
    Schema.validate(
      schema,
      :size,
      fn tuple -> tuple_size(tuple) == count end,
      %{count: count}
    )
  end

  @spec shape(t, tuple) :: t
  def shape(%Schema{name: :tuple} = schema \\ t(), structure)
      when is_tuple(structure) do
    expected_size = tuple_size(structure)

    Schema.validate(
      schema,
      :shape,
      fn tuple ->
        if tuple_size(tuple) == expected_size do
          Enum.reduce_while(0..(expected_size - 1), :ok, fn index, _ ->
            schema = elem(structure, index)
            value = elem(tuple, index)

            case Schema.eval(schema, value) do
              :ok -> {:cont, :ok}
              {:error, error} -> {:halt, error}
            end
          end)
        else
          :error
        end
      end,
      %{structure: structure}
    )
  end
end
