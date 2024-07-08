defmodule Vx.Constrained do
  @moduledoc """
  A type that wraps a schema and applies constraints to it.
  """

  @enforce_keys [:type]
  defstruct [:type, constraints: MapSet.new()]

  @type t(wrapped) :: %__MODULE__{
          type: wrapped,
          constraints: MapSet.t(Vx.t())
        }

  @type t :: t(Vx.t())

  @doc false
  @spec wrap(wrapped | t(wrapped)) :: t(wrapped)
        when wrapped: Vx.t()
  def wrap(type)
  def wrap(%__MODULE__{} = constrained), do: constrained
  def wrap(type), do: %__MODULE__{type: type}

  @doc false
  @spec put_constraint(t, Vx.t()) :: t
  def put_constraint(%__MODULE__{} = constrained, constraint) do
    Map.update!(constrained, :constraints, &MapSet.put(&1, constraint))
  end

  defimpl Vx.Validatable do
    def validate(%{type: type, constraints: constraints}, value) do
      with [] <- Vx.Validatable.validate(type, value) do
        Enum.flat_map(constraints, &Vx.Validatable.validate(&1, value))
      end
    end
  end
end
