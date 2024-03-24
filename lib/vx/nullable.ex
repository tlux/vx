defmodule Vx.Nullable do
  @moduledoc """
  The Nullable type modifies a type or value to allow `nil` as a valid value.
  """

  @enforce_keys [:of]
  defstruct [:of]

  @type t :: t(any)
  @opaque t(of) :: %__MODULE__{of: of}

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
  @spec t(of) :: t(of) when of: any
  def t(of) do
    %__MODULE__{of: of}
  end

  defimpl Vx.Validatable do
    def validate(_, nil), do: :ok

    def validate(%{of: of}, value) do
      case Vx.Validatable.validate(of, value) do
        :ok ->
          :ok

        {:error, _} ->
          {:error, "must be #{Vx.Inspectable.inspect(Vx.Nullable.t(of))}"}
      end
    end
  end

  defimpl Vx.Inspectable do
    def inspect(%{of: of}) do
      [of, nil]
      |> Vx.Union.t()
      |> Vx.Inspectable.inspect()
    end
  end
end
