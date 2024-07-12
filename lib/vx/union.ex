defmodule Vx.Union do
  @moduledoc """
  The Union type combines multiple types into a single type, validating
  whether any of them is valid.
  """

  @enforce_keys [:aug, :add]
  defstruct [:aug, :add]

  @doc """
  Builds a new Union type.

  # Examples

      iex> Vx.Union.t(Vx.Integer.t(), Vx.String.t()) |> Vx.valid?(123)
      true

      iex> Vx.Union.t(Vx.Integer.t(), Vx.String.t()) |> Vx.valid?(:foo)
      false
  """
  @spec t(Vx.t(), Vx.t()) :: Vx.t()
  def t(aug, add) do
    %__MODULE__{aug: aug, add: add}
  end

  @spec t(nonempty_list(Vx.t())) :: Vx.t()
  def t([_, _ | _] = list) when is_list(list) do
    Enum.reduce(list, fn item, acc ->
      t(acc, item)
    end)
  end

  defimpl Vx.Validatable do
    def validate(%{aug: aug, add: add} = schema, value) do
      with {:aug, []} <- {:aug, Vx.Validatable.validate(aug, value)},
           {:add, []} <- {:add, Vx.Validatable.validate(add, value)} do
        []
      else
        _ ->
          [
            Vx.Error.new(
              schema,
              value,
              "must be #{inspect(aug)} or #{inspect(add)}"
            )
          ]
      end
    end
  end
end
