defmodule Vx.Not do
  @moduledoc """
  The Not type negates the given type or value.
  """

  @enforce_keys [:of]
  defstruct [:of]

  @type t :: t(Vx.t())
  @opaque t(of) :: %__MODULE__{of: of}

  @doc """
  Builds a new type negating the passed one.

  ## Examples

      iex> Vx.Not.t(Vx.Integer.t()) |> Vx.validate!("foo")
      :ok

      iex> Vx.Not.t(Vx.Integer.t()) |> Vx.validate!(123)
      ** (Vx.Error) must not be integer
  """
  @spec t(of) :: t(of) when of: Vx.t()
  def t(of) do
    %__MODULE__{of: of}
  end

  defimpl Vx.Validatable do
    def validate(%{of: of}, value) do
      case Vx.Validatable.validate(of, value) do
        :ok -> {:error, "must not be #{Vx.Inspectable.inspect(of)}"}
        {:error, _} -> :ok
      end
    end
  end

  defimpl Vx.Inspectable do
    def inspect(%{of: of}) do
      "!" <> Vx.Inspectable.inspect(of)
    end
  end
end
