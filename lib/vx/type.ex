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
        validate(
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

  defmacro __using__(_) do
    quote do
      defstruct [:validators]

      @type t :: %__MODULE__{validators: Validators.t()}

      defp init do
        %__MODULE__{validators: Validators.new(__MODULE__)}
      end

      defp init(fun, details \\ %{}, message \\ nil) do
        %__MODULE__{
          validators: Validators.new(__MODULE__, fun, details, message)
        }
      end

      defp validate(type, name, fun, details \\ %{}, message \\ nil) do
        %{
          type
          | validators:
              Validators.add(type.validators, name, fun, details, message)
        }
      end

      defimpl Vx.Validatable do
        def validate(type, value) do
          Validators.run(type.validators, value)
        end
      end
    end
  end
end
