defmodule Vx.Constrained do
  @moduledoc """
  A type that wraps a schema and applies constraints to it.
  """
  @moduledoc since: "1.0.0"

  @enforce_keys [:schema]
  defstruct [:schema, constraints: MapSet.new()]

  @doc """
  Wrap a schema in a `Vx.Constrained`.

  Is a no-op when the passed schema is already a `Vx.Constrained`.
  """
  @spec t(Vx.t()) :: Vx.t()
  def t(schema)
  def t(%__MODULE__{} = constrained), do: constrained
  def t(schema), do: %__MODULE__{schema: schema}

  @doc """
  Adds a constraint to a `Vx.Constrained` schema.
  """
  @spec put_constraint(Vx.t(), Vx.t()) :: Vx.t()
  def put_constraint(%__MODULE__{} = constrained, constraint) do
    Map.update!(constrained, :constraints, &MapSet.put(&1, constraint))
  end

  defimpl Vx.Validatable do
    def validate(%{schema: schema, constraints: constraints}, value) do
      with :ok <- Vx.validate(schema, value) do
        constraints
        |> Enum.flat_map(&Vx.errors_on(&1, value))
        |> then(fn
          [] -> :ok
          errors -> {:error, errors}
        end)
      end
    end
  end

  defimpl Vx.Humanizable do
    def humanize(%{schema: schema, constraints: constraints}) do
      suffix =
        case MapSet.size(constraints) do
          0 ->
            ""

          _ ->
            "[" <>
              Enum.map_join(constraints, ", ", &Vx.Humanizable.humanize/1) <>
              "]"
        end

      Vx.Humanizable.humanize(schema) <> suffix
    end
  end
end
