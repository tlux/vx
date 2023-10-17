defmodule Vx.Common do
  alias Vx.Schema

  def eq(%Schema{} = schema, value) do
    Schema.validate(schema, :eq, fn
      ^value -> true
      _ -> false
    end)
  end
end
