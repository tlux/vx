defmodule Vx.Nullable do
  @moduledoc """
  The Nullable type modifies a type or value to allow `nil` as a valid value.
  """

  @enforce_keys [:of]
  defstruct [:of]

  @type t(of) :: %__MODULE__{of: of}
  @type t :: t(Vx.t())

  @doc """
  Builds a new type that makes the passed type nullable.

  ## Examples

      iex> Vx.Nullable.t(Vx.String.t()) |> Vx.validate!("foo")
      :ok

      iex> Vx.Nullable.t(Vx.String.t()) |> Vx.validate!(nil)
      :ok

      iex> Vx.Nullable.t(Vx.String.t()) |> Vx.validate!(123)
      ** (Vx.Error) must be (string | nil)
  """
  @spec t(Vx.t()) :: Vx.t()
  def t(of), do: %__MODULE__{of: of}

  defimpl Vx.Validatable do
    def validate(_, nil), do: []

    def validate(%{of: of}, value) do
      Vx.Validatable.validate(of, value)
    end
  end
end
