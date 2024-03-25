defmodule Vx.Union do
  @moduledoc """
  The Union type combines multiple types into a single type, validating
  whether any of them is valid.
  """

  @enforce_keys [:of]
  defstruct [:of]

  @type t :: t(nonempty_list(Vx.schema()))
  @opaque t(of) :: %__MODULE__{of: of}

  @doc """
  Builds a new Union type.

  # Examples

      iex> Vx.Union.t([Vx.Integer.t(), Vx.String.t()]) |> Vx.validate!(123)
      :ok

      iex> Vx.Union.t([Vx.Integer.t(), Vx.String.t()]) |> Vx.validate!(:foo)
      ** (Vx.Error) must be any of (integer | string)
  """
  @spec t(of) :: t(of) when of: nonempty_list(Vx.schema())
  def t([_ | _] = of) do
    %__MODULE__{of: of}
  end

  defimpl Vx.Validatable do
    def validate(%{of: [of]}, value) do
      Vx.Validatable.validate(of, value)
    end

    def validate(%{of: of}, value) do
      errors =
        Enum.flat_map(of, fn type ->
          case Vx.Validatable.validate(type, value) do
            :ok -> []
            {:error, message} -> ["- #{message}"]
          end
        end)

      if length(errors) == length(of) do
        {:error, "must be any of #{Vx.Inspectable.inspect(Vx.Union.t(of))}"}
      else
        :ok
      end
    end
  end

  defimpl Vx.Inspectable do
    def inspect(%{of: of}) do
      "(" <> Enum.map_join(of, " | ", &Vx.Inspectable.inspect/1) <> ")"
    end
  end
end
