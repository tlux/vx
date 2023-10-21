defmodule Vx.Validators do
  @moduledoc """
  A struct that represents a list of validators.
  """

  alias Vx.TypeError
  alias Vx.Validator

  defstruct [:schema, list: []]

  @opaque t :: %__MODULE__{schema: module, list: [Validator.t()]}

  @spec new(module) :: t
  def new(schema) do
    %__MODULE__{schema: schema}
  end

  @doc """
  Builds a new validator collection.
  """
  @spec new(module, Validator.fun(), Validator.details()) :: t
  def new(schema, fun, details \\ %{}) when is_atom(schema) do
    %__MODULE__{
      schema: schema,
      list: [Validator.new(schema, nil, fun, details)]
    }
  end

  @doc """
  Adds a validator to the collection.
  """
  @spec add(t, Validator.name(), Validator.fun(), Validator.details()) :: t
  def add(
        %__MODULE__{schema: schema, list: list} = validators,
        name,
        fun,
        details \\ %{}
      ) do
    %{validators | list: [Validator.new(schema, name, fun, details) | list]}
  end

  @doc """
  Runs all validators in the list.
  """
  @spec run(t, any) :: :ok | {:error, TypeError.t()}
  def run(%__MODULE__{list: list}, value) do
    list
    |> Enum.reverse()
    |> Enum.reduce_while(:ok, fn validator, _ ->
      case Validator.run(validator, value) do
        :ok -> {:cont, :ok}
        error -> {:halt, error}
      end
    end)
  end
end
