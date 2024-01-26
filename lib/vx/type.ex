defmodule Vx.Type do
  @moduledoc """
  The Type module provides a default implementation for types.
  You can use it to define custom types for your application.

  ## Example

    defmodule MyType do
      use Vx.Type

      def t do
        init(fn actual_value -> is_string(actual_value) end)
      end

      def equal(%__MODULE__{} = type \\ t(), expected_value) do
        add_validator(
          type,
          :equal,
          fn actual_value -> actual_value == expected_value end,
          %{expected_value: expected_value},
          "is not equal to \#{inspect(expected_value)}"
        )
      end
    end
  """

  alias Vx.Validators

  @type t :: %{
          :__struct__ => module,
          :validators => Vx.Validators.t(),
          optional(atom) => any
        }

  @doc false
  @spec new(module) :: t
  def new(module) do
    struct!(module, validators: Validators.new(module))
  end

  @doc false
  @spec new(
          module,
          Vx.Validator.fun(),
          Vx.Validator.details(),
          Vx.Validator.message() | nil
        ) :: t
  def new(module, fun, details \\ %{}, message \\ nil) do
    struct!(module, validators: Validators.new(module, fun, details, message))
  end

  @doc false
  @spec add_validator(
          t,
          Vx.Validator.name(),
          Vx.Validator.fun(),
          Vx.Validator.details(),
          Vx.Validator.message() | nil
        ) :: t
  def add_validator(type, name, fun, details \\ %{}, message \\ nil) do
    %{
      type
      | validators: Validators.add(type.validators, name, fun, details, message)
    }
  end

  defmacro __using__(_) do
    quote do
      defstruct [:validators]

      @type t :: %__MODULE__{validators: Validators.t()}

      defp init do
        Vx.Type.new(__MODULE__)
      end

      defp init(fun, details \\ %{}, message \\ nil) do
        Vx.Type.new(__MODULE__, fun, details, message)
      end

      defp add_validator(type, name, fun, details \\ %{}, message \\ nil) do
        Vx.Type.add_validator(type, name, fun, details, message)
      end

      defimpl Vx.Validatable do
        def validate(type, value) do
          Validators.run(type.validators, value)
        end
      end
    end
  end
end
