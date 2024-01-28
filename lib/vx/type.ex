defmodule Vx.Type do
  @moduledoc """
  The Type module provides a default implementation for types.
  You can use it to define custom types for your application.

  ## Example

    defmodule MyType do
      use Vx.Type

      def t do
        new(fn actual_value -> is_string(actual_value) end)
      end

      def equal(%__MODULE__{} = type \\ t(), expected_value) do
        add_rule(
          type,
          :equal,
          fn actual_value -> actual_value == expected_value end,
          %{expected_value: expected_value},
          "is not equal to \#{inspect(expected_value)}"
        )
      end
    end
  """

  alias Vx.Validator

  defstruct [:module, :check, rules: []]

  @type t(mod) :: %__MODULE__{
          module: mod,
          check: Validator.t() | nil,
          rules: [Validator.t()]
        }

  @type t :: t(module)

  @type type(mod) :: t(mod) | %{__struct__: mod, __type__: t(mod)}

  @type type :: type(module)

  @doc false
  @spec new(mod) :: t(mod) when mod: module
  def new(module) do
    %__MODULE__{module: module}
  end

  @doc false
  @spec new(
          mod,
          Validator.fun(),
          Validator.details(),
          Validator.message() | nil
        ) :: t(mod)
        when mod: module
  def new(module, fun, details \\ %{}, message \\ nil) do
    %__MODULE__{
      module: module,
      check: Validator.new(module, nil, fun, details, message)
    }
  end

  @spec add_rule(
          t,
          Validator.name(),
          Validator.fun(),
          Validator.details(),
          Validator.message() | nil
        ) :: t

  def add_rule(%__MODULE__{} = type, name, fun, details \\ %{}, message \\ nil) do
    %{
      type
      | rules: [
          Validator.new(type.module, name, fun, details, message)
          | type.rules
        ]
    }
  end

  @doc """
  Validates a value against the type.
  """
  @spec validate(type, any) :: :ok | {:error, Vx.ValidationError.t()}
  def validate(%__MODULE__{check: nil} = type, value) do
    validate_rules(type, value)
  end

  def validate(%__MODULE__{check: check} = type, value) do
    with :ok <- Validator.run(check, value) do
      validate_rules(type, value)
    end
  end

  def validate(type, value) do
    type |> resolve_type() |> validate(value)
  end

  @doc """
  Validates a value exclusively against the type's rules without performing any
  type check.
  """
  @spec validate_rules(type, any) :: :ok | {:error, Vx.ValidationError.t()}
  def validate_rules(%__MODULE__{} = type, value) do
    type
    |> get_rules()
    |> Enum.reduce_while(:ok, fn validator, _ ->
      case Validator.run(validator, value) do
        :ok -> {:cont, :ok}
        error -> {:halt, error}
      end
    end)
  end

  def validate_rules(type, value) do
    type |> resolve_type() |> validate_rules(value)
  end

  @doc """
  Gets details for the type check validator.
  """
  @spec details(type) :: Validator.details() | nil
  def details(%__MODULE__{check: nil}), do: %{}

  def details(%__MODULE__{check: check}), do: check.details

  def details(type) do
    type |> resolve_type() |> details()
  end

  @doc """
  Gets details for the rule validator with the given name.
  """
  @spec details(type, Validator.name()) :: Validator.details() | nil
  def details(%__MODULE__{} = type, rule) do
    type
    |> get_rules()
    |> Enum.find_value(%{}, fn
      %Validator{name: ^rule, details: details} -> details
      _ -> nil
    end)
  end

  def details(type, rule) do
    type |> resolve_type() |> details(rule)
  end

  @doc """
  A list of all validation rules defined for the type.
  """
  @spec validators(type) :: [Validator.t()]
  def validators(%__MODULE__{check: nil} = type), do: get_rules(type)

  def validators(%__MODULE__{check: check} = type) do
    [check | get_rules(type)]
  end

  def validators(type) do
    type |> resolve_type() |> validators()
  end

  defp resolve_type(%_{__type__: %__MODULE__{} = type}), do: type
  defp resolve_type(%__MODULE__{} = type), do: type

  defp get_rules(%__MODULE__{rules: rules}), do: Enum.reverse(rules)

  defmacro __using__(_) do
    quote do
      defstruct [:__type__]

      @type t :: %__MODULE__{__type__: Vx.Type.t(__MODULE__)}

      defp new do
        %__MODULE__{__type__: Vx.Type.new(__MODULE__)}
      end

      defp new(fun, details \\ %{}, message \\ nil) do
        %__MODULE__{__type__: Vx.Type.new(__MODULE__, fun, details, message)}
      end

      defp add_rule(type, name, fun, details \\ %{}, message \\ nil) do
        %{
          type
          | __type__:
              Vx.Type.add_rule(type.__type__, name, fun, details, message)
        }
      end

      defimpl Vx.Validatable do
        def validate(%{__type__: type}, value) do
          Vx.Type.validate(type, value)
        end
      end
    end
  end
end
