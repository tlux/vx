defmodule Vx.Not do
  @moduledoc """
  The Not type negates the given type or value.
  """

  @enforce_keys [:of]
  defstruct [:of]

  @doc """
  Builds a new type negating the passed one.

  ## Examples

      iex> Vx.Not.t(Vx.Integer.t()) |> Vx.validate!("foo")
      :ok

      iex> Vx.Not.t(Vx.Integer.t()) |> Vx.validate!(123)
      ** (Vx.Error) must not be integer
  """
  @spec t(Vx.t()) :: Vx.t()
  def t(of), do: %__MODULE__{of: of}

  defimpl Vx.Validatable do
    def validate(%{of: of} = schema, value) do
      case Vx.Validatable.validate(of, value) do
        [] ->
          # TODO: improve message
          [Vx.Error.new(schema, value, "must not be #{inspect(of)}")]

        _ ->
          []
      end
    end
  end
end
