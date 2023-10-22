defmodule Vx.Validators do
  @moduledoc """
  A struct that represents a list of validators.
  """

  alias Vx.TypeError
  alias Vx.Validator

  defstruct [:type, list: []]

  @opaque t :: %__MODULE__{type: module, list: [Validator.t()]}

  @spec new(module) :: t
  def new(type) do
    %__MODULE__{type: type}
  end

  @doc """
  Builds a new validator collection.
  """
  @spec new(module, Validator.fun(), Validator.details()) :: t
  def new(type, fun, details \\ %{}) when is_atom(type) do
    %__MODULE__{
      type: type,
      list: [Validator.new(type, nil, fun, details)]
    }
  end

  @doc """
  Adds a validator to the collection.
  """
  @spec add(t, Validator.name(), Validator.fun(), Validator.details()) :: t
  def add(
        %__MODULE__{type: type, list: list} = validators,
        name,
        fun,
        details \\ %{}
      ) do
    %{validators | list: [Validator.new(type, name, fun, details) | list]}
  end

  @doc """
  Gets the primary validator.
  """
  @spec primary_validator(t) :: Validator.t() | nil
  def primary_validator(%__MODULE__{list: validators}) do
    Enum.find(validators, &is_nil(&1.name))
  end

  @doc false
  @spec to_list(t) :: [Validator.t()]
  def to_list(%__MODULE__{list: list}) do
    Enum.reverse(list)
  end

  @doc """
  Runs all validators in the list.
  """
  @spec run(t, any) :: :ok | {:error, TypeError.t()}
  def run(%__MODULE__{} = validators, value) do
    validators
    |> to_list()
    |> Enum.reduce_while(:ok, fn validator, _ ->
      case Validator.run(validator, value) do
        :ok -> {:cont, :ok}
        error -> {:halt, error}
      end
    end)
  end
end
