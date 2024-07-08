defmodule Vx.Union do
  @moduledoc """
  The Union type combines multiple types into a single type, validating
  whether any of them is valid.
  """

  @enforce_keys [:of]
  defstruct [:of]

  @doc """
  Builds a new Union type.

  # Examples

      iex> Vx.Union.t([Vx.Integer.t(), Vx.String.t()]) |> Vx.validate!(123)
      :ok

      iex> Vx.Union.t([Vx.Integer.t(), Vx.String.t()]) |> Vx.validate!(:foo)
      ** (Vx.Error) must be any of (integer | string)
  """
  @spec t(nonempty_list(Vx.t())) :: Vx.t()
  def t([_ | _] = of), do: %__MODULE__{of: of}

  defimpl Vx.Validatable do
    def validate(%{of: [of]}, value) do
      Vx.Validatable.validate(of, value)
    end

    def validate(%{of: of} = schema, value) do
      of
      |> Enum.reduce_while([], fn schema, acc ->
        case Vx.Validatable.validate(schema, value) do
          [] -> {:halt, []}
          errors -> {:cont, acc ++ errors}
        end
      end)
      |> then(fn
        [] ->
          []

        errors ->
          [
            Vx.Error.new(
              schema,
              value,
              "does not match any\n" <>
                Enum.map_join(errors, "\n", &"- #{&1.message}")
            )
          ]
      end)
    end
  end
end
