defmodule FunctionValidator do
  defstruct [:fun]

  defimpl Vx.Validatable do
    def validate(%{fun: fun}, value) do
      fun.(value)
    end
  end
end
