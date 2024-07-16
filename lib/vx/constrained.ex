defmodule Vx.Constrained do
  @moduledoc """
  A type that wraps a schema and applies constraints to it.
  """
  @moduledoc since: "1.0.0"

  @enforce_keys [:type]
  defstruct [:type, constraints: MapSet.new()]

  @type t(wrapped) :: %__MODULE__{
          type: wrapped,
          constraints: MapSet.t(Vx.t())
        }

  @type t :: t(Vx.t())

  @doc """
  Wrap a schema in a `Vx.Constrained`.

  Is a no-op when the passed schema is already a `Vx.Constrained`.
  """
  @spec wrap(wrapped | t(wrapped)) :: t(wrapped)
        when wrapped: Vx.t()
  def wrap(type)
  def wrap(%__MODULE__{} = constrained), do: constrained
  def wrap(type), do: %__MODULE__{type: type}

  @doc """
  Adds a constraint to a `Vx.Constrained` schema.
  """
  @spec put_constraint(t, Vx.t()) :: t
  def put_constraint(%__MODULE__{} = constrained, constraint) do
    Map.update!(constrained, :constraints, &MapSet.put(&1, constraint))
  end

  defimpl Vx.Validatable do
    def validate(%{type: type, constraints: constraints}, value) do
      with :ok <- Vx.validate(type, value) do
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
    def humanize(%{type: type, constraints: constraints}) do
      suffix =
        case MapSet.size(constraints) do
          0 ->
            ""

          _ ->
            "[" <>
              Enum.map_join(constraints, ", ", &Vx.Humanizable.humanize/1) <>
              "]"
        end

      Vx.Humanizable.humanize(type) <> suffix
    end
  end
end
