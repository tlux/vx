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
