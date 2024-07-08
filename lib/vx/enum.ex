defmodule Vx.Enum do
  @moduledoc """
  The Enum type.
  """

  @enforce_keys [:values]
  defstruct [:values]

  @doc """
  Builds a new Enum type.

  ## Examples

      iex> Vx.Enum.t([:foo, :bar]) |> Vx.validate!(:foo)
      :ok

      iex> Vx.Enum.t([:foo, :bar]) |> Vx.validate!(:baz)
      ** (Vx.Error) must be one of :foo, :bar
  """
  @spec t(nonempty_list) :: Vx.t()
  def t([_ | _] = values) when is_list(values) do
    %__MODULE__{values: values}
  end

  defimpl Vx.Validatable do
    def validate(%{values: values} = schema, value) do
      if value in values do
        []
      else
        [
          Vx.Error.new(
            schema,
            value,
            "is not one of #{Vx.Util.inspect_enum(values)}"
          )
        ]
      end
    end
  end
end
