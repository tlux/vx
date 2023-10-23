defmodule Vx.Validators do
  @moduledoc """
  A struct that represents a list of validators.
  """

  alias Vx.ValidationError
  alias Vx.Validator

  defstruct [:type, :default, list: []]

  @opaque t :: %__MODULE__{
            type: module,
            default: Validator.t() | nil,
            list: [Validator.t()]
          }

  @doc """
  Builds a new validator collection without a default validator.
  """
  @spec new(module) :: t
  def new(type) when is_atom(type) do
    %__MODULE__{type: type}
  end

  @doc """
  Builds a new validator collection setting a default validator.
  """
  @spec new(module, Validator.fun(), Validator.details()) :: t
  def new(type, fun, details \\ %{}) when is_atom(type) do
    %__MODULE__{
      type: type,
      default: Validator.new(type, nil, fun, details)
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
  Gets the default validator.
  """
  @spec default(t) :: Validator.t() | nil
  def default(%__MODULE__{default: default}), do: default

  @doc false
  @spec to_list(t) :: [Validator.t()]
  def to_list(%__MODULE__{default: nil, list: list}) do
    Enum.reverse(list)
  end

  def to_list(%__MODULE__{default: default, list: list}) do
    [default | Enum.reverse(list)]
  end

  @doc """
  Runs all validators in the list.
  """
  @spec run(t, any) :: :ok | {:error, ValidationError.t()}
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
