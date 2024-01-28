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
  @spec validate(t, any) :: :ok | {:error, Vx.ValidationError.t()}
  def validate(%__MODULE__{check: nil} = type, value) do
    validate_rules(type, value)
  end

  def validate(%__MODULE__{check: check} = type, value) do
    with :ok <- Validator.run(check, value) do
      validate_rules(type, value)
    end
  end

  @doc """
  Validates a value exclusively against the type's rules without performing any
  type check.
  """
  @spec validate_rules(t, any) :: :ok | {:error, Vx.ValidationError.t()}
  def validate_rules(%__MODULE__{rules: rules}, value) do
    rules
    |> Enum.reverse()
    |> Enum.reduce_while(:ok, fn validator, _ ->
      case Validator.run(validator, value) do
        :ok -> {:cont, :ok}
        error -> {:halt, error}
      end
    end)
  end

  # @doc """
  # Gets details for the type validator.
  # """
  # @spec details(t) :: Validator.details() | nil
  # def details(%{validators: validators}) do
  #   case Validators.type(validators) do
  #     %{details: details} -> details
  #     nil -> nil
  #   end
  # end

  # @doc """
  # Gets details for the rule validator with the given name.
  # """
  # @spec details(t, Validator.name()) :: Validator.details() | nil
  # def details(%{validators: validators}, validator) do
  #   case Validators.fetch_rule(validators, validator) do
  #     {:ok, %{details: details}} -> details
  #     :error -> nil
  #   end
  # end

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
