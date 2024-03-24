defmodule Vx.Optional do
  @moduledoc """
  The Optional type provides validators for optional keys in a map. When used in
  other places, it behaves like `Vx.Nullable`.
  """

  @enforce_keys [:of]
  defstruct [:of]

  @type t :: t(any)
  @opaque t(of) :: %__MODULE__{of: of}

  @doc """
  Builds a new type that makes the passed type optional.

  ## Examples

      iex> Vx.Optional.t(Vx.String.t()) |> Vx.validate!("foo")
      :ok

      iex> Vx.Optional.t(Vx.String.t()) |> Vx.validate!(nil)
      :ok

      iex> Vx.Optional.t(Vx.String.t()) |> Vx.validate!(123)
      ** (Vx.Error) must be string?

  In most cases the behavior is the same as using `Vx.Nullable.t/1`.

  Besides that, you can use `Vx.Optional.t/1` to mark map keys as optional.

      iex> schema = Vx.Map.shape(%{
      ...>   :a => Vx.String.t(),
      ...>   Vx.Optional.t(:b) => Vx.Number.t()
      ...> })
      ...> Vx.validate!(schema, %{a: "foo"})
      :ok

      iex> schema = Vx.Map.shape(%{
      ...>   :a => Vx.String.t(),
      ...>   Vx.Optional.t(:b) => Vx.Number.t()
      ...> })
      ...> Vx.validate!(schema, %{a: "foo", b: "bar"})
      ** (Vx.Error) does not match shape
      - key :b: must be a number
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
