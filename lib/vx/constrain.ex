defmodule Vx.Constrain do
  @moduledoc """
  A module that provides functions for adding constraints to types.
  """

  alias Vx.Constrained

  @doc """
  Adds a constraint to a schema.
  """
  @spec constrain_any(Vx.t(), Vx.t()) :: Vx.t()
  def constrain_any(schema, constraint) do
    schema
    |> Constrained.t()
    |> Constrained.put_constraint(constraint)
  end

  @doc """
  Adds a constraint to a schema only if the type is one of the expected types.
  """
  @spec constrain_only(Vx.t(), module | [module], Vx.t()) :: Vx.t()
  def constrain_only(schema, permitted, constraint) when is_list(permitted) do
    type = type_of(schema)

    unless type in permitted do
      raise %Vx.IncompatibleConstraintError{
        constraint: constraint,
        permitted: permitted,
        actual: type
      }
    end

    constrain_any(schema, constraint)
  end

  def constrain_only(schema, permitted, constraint) when is_atom(permitted) do
    constrain_only(schema, [permitted], constraint)
  end

  defp type_of(%Constrained{schema: %type{}}), do: type
  defp type_of(%type{}), do: type
end
