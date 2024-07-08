defmodule Vx.Except do
  @enforce_keys [:min, :sub]
  defstruct [:min, :sub]

  @spec t(Vx.t(), Vx.t()) :: Vx.t()
  def t(min, sub) do
    %__MODULE__{min: min, sub: sub}
  end

  @spec t([Vx.t()]) :: Vx.t()
  def t([_ | _] = list) when is_list(list) do
    Enum.reduce(list, fn item, acc ->
      t(acc, item)
    end)
  end

  defimpl Vx.Validatable do
    def validate(%{min: min, sub: sub} = schema, value) do
      with {:min, []} <- {:min, Vx.Validatable.validate(min, value)},
           {:sub, []} <- {:sub, Vx.Validatable.validate(sub, value)} do
        [Vx.Error.new(schema, value, "must not be #{inspect(sub)}")]
      else
        {:min, errors} -> errors
        {:sub, _} -> []
      end
    end
  end
end
