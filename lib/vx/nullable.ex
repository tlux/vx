defmodule Vx.Nullable do
  @moduledoc """
  The Nullable type modifies a type or value to allow `nil` as a valid value.
  """

  @enforce_keys [:schema]
  defstruct [:schema]

  @type t(schema) :: %__MODULE__{schema: schema}
  @type t :: t(Vx.t())

  @doc """
  Builds a new type that makes the passed type nullable.

  ## Examples

      iex> Vx.Nullable.t(Vx.String.t()) |> Vx.valid?("foo")
      true

      iex> Vx.Nullable.t(Vx.String.t()) |> Vx.valid?(nil)
      true

      iex> Vx.Nullable.t(Vx.String.t()) |> Vx.valid?(123)
      false
  """
  @spec t(Vx.t()) :: Vx.t()
  def t(%Vx.Nullable{} = schema), do: schema

  def t(%Vx.Optional{schema: schema}), do: t(schema)

  def t(schema), do: %__MODULE__{schema: schema}

  defimpl Vx.Validatable do
    def validate(_, nil), do: :ok

    def validate(%{schema: schema} = nullable, value) do
      case Vx.validate(schema, value) do
        :ok ->
          :ok

        {:error, errors} ->
          {:error, Enum.map(errors, &Vx.Error.put_schema(&1, nullable))}
      end
    end
  end

  defimpl Vx.Humanizable do
    def humanize(%{schema: schema}) do
      "#{Vx.Humanizable.humanize(schema)}?"
    end
  end
end
