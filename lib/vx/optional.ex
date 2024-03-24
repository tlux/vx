defmodule Vx.Optional do
  @moduledoc """
  The Optional type provides validators for optional keys in a map. When used in
  other places, it behaves like `Vx.Nullable`.
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
          {:error, "must be #{Vx.Inspectable.inspect(Vx.Optional.t(of))}"}
      end
    end
  end

  defimpl Vx.Inspectable do
    def inspect(%{of: of}) do
      Vx.Inspectable.inspect(of) <> "?"
    end
  end
end
