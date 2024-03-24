defmodule Vx.Nullable do
  @moduledoc """
  The Nullable type modifies a type or value to allow `nil` as a valid value.
  """

  @enforce_keys [:of]
  defstruct [:of]

  @type t :: t(Vx.t())
  @opaque t(of) :: %__MODULE__{of: of}

  @spec t(of) :: t(of) when of: Vx.t()
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
