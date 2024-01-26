defmodule Vx.Validators do
  @moduledoc """
  A struct that represents a list of validators.
  """

  alias Vx.ValidationError
  alias Vx.Validator

  defstruct [:module, :default, list: []]

  @opaque t :: %__MODULE__{
            module: module,
            default: Validator.t() | nil,
            list: [Validator.t()]
          }

  @doc """
  Builds a new validator collection without a default validator.
  """
  @spec new(module) :: t
  def new(module) when is_atom(module) do
    %__MODULE__{module: module}
  end

  @doc """
  Builds a new validator collection setting a default validator.
  """
  @spec new(
          module,
          Validator.fun(),
          Validator.details(),
          Validator.message() | nil
        ) :: t
  def new(module, fun, details \\ %{}, message \\ nil) when is_atom(module) do
    %__MODULE__{
      module: module,
      default: Validator.new(module, nil, fun, details, message)
    }
  end

  @doc """
  Adds a validator to the collection.
  """
  @spec add(
          t,
          Validator.name(),
          Validator.fun(),
          Validator.details(),
          Validator.message() | nil
        ) :: t
  def add(
        %__MODULE__{module: module, list: list} = validators,
        name,
        fun,
        details \\ %{},
        message \\ nil
      ) do
    %{
      validators
      | list: [Validator.new(module, name, fun, details, message) | list]
    }
  end

  @doc """
  Gets the default validator.
  """
  @spec default(t) :: Validator.t() | nil
  def default(%__MODULE__{default: default}), do: default

  @doc """
  Gets the validator with the given name.
  """
  @spec fetch(t, Validator.name()) :: {:ok, Validator.t()} | :error
  def fetch(%__MODULE__{list: list}, name) do
    Enum.find_value(list, :error, fn
      %{name: ^name} = validator -> {:ok, validator}
      _ -> nil
    end)
  end

  @doc """
  Gets all validators as a list.
  """
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
