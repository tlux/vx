defmodule Vx.Constrained do
  @moduledoc """
  A type that wraps a schema and applies constraints to it.

  The constraints are only validated when the associated schema is valid.
  """
  @moduledoc since: "1.0.0"

  @enforce_keys [:schema]
  defstruct [:schema, constraints: MapSet.new()]

  @type t :: %__MODULE__{schema: Vx.t(), constraints: MapSet.t(Vx.t())}

  @doc """
  Wrap a schema in a `Vx.Constrained`.

  Is a no-op when the passed schema is already a `Vx.Constrained`.
  """
  @spec t(Vx.t()) :: t
  def t(schema)
  def t(%__MODULE__{} = constrained), do: constrained
  def t(schema), do: %__MODULE__{schema: schema}

  @doc """
  Wraps a schema in a `Vx.Constrained` and adds the given constraint(s) in one
  pass.
  """
  @spec t(Vx.t(), Vx.t() | [Vx.t()]) :: t
  def t(schema, constraint_or_constraints)

  def t(schema, constraints) when is_list(constraints) do
    Enum.reduce(constraints, t(schema), &put_constraint(&2, &1))
  end

  def t(schema, constraint) do
    schema
    |> t()
    |> put_constraint(constraint)
  end

  @doc """
  Returns the constraints on the schema.
  """
  @spec constraints(t) :: [Vx.t()]
  def constraints(%__MODULE__{constraints: constraints}) do
    Enum.to_list(constraints)
  end

  @doc """
  Adds a constraint to a `Vx.Constrained` schema.
  """
  @spec put_constraint(t, Vx.t()) :: t
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

  defimpl Vx.Printable do
    def print(%{schema: schema, constraints: constraints}) do
      suffix =
        case MapSet.size(constraints) do
          0 ->
            ""

          _ ->
            "[" <>
              Enum.map_join(constraints, ", ", &Vx.Printable.print/1) <>
              "]"
        end

      Vx.Printable.print(schema) <> suffix
    end
  end
end
