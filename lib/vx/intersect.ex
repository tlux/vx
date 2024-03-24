defmodule Vx.Intersect do
  @moduledoc """
  The Intersect type combines multiple types into a single type, validating
  whether all of them are valid.
  """

  @enforce_keys [:of]
  defstruct [:of]

  @type t :: t(nonempty_list(Vx.t()))
  @opaque t(of) :: %__MODULE__{of: of}

  @doc """
  Builds a new Intersect type.

  ## Examples

      iex> Vx.Intersect.t([Vx.Integer.t(), Vx.Number.t()]) |> Vx.validate!(123)
      :ok

      iex> Vx.Intersect.t([Vx.Integer.t(), Vx.Number.t()]) |> Vx.validate!(12.3)
      ** (Vx.Error) must be all of (integer & number)
  """
  @spec t(of) :: t(of) when of: nonempty_list(Vx.t())
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

      if errors == [] do
        :ok
      else
        {:error, "must be all of #{Vx.Inspectable.inspect(Vx.Intersect.t(of))}"}
      end
    end
  end

  defimpl Vx.Inspectable do
    def inspect(%{of: of}) do
      "(" <> Enum.map_join(of, " & ", &Vx.Inspectable.inspect/1) <> ")"
    end
  end
end
