defmodule Vx.Type do
  alias Vx.Validator

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

  defmacro __using__(_) do
    quote do
      defstruct [:type, rules: []]

      @type t :: %__MODULE__{type: Validator.t(), rules: [Validator.t()]}

      defp new do
        %__MODULE__{type: Validator.noop()}
      end

      defp new(fun, details \\ %{}, message \\ nil) do
        %__MODULE__{type: Validator.new(fun, details, message)}
      end

      defp add_rule(
             %_{rules: rules} = type,
             name,
             fun,
             details \\ %{},
             message \\ nil
           )
           when is_list(rules) do
        %{type | rules: [Validator.new(fun, details, message) | rules]}
      end

      defimpl Vx.Validatable2 do
        def type(%{type: type}), do: type
        def rules(%{rules: rules}), do: Enum.reverse(rules)
      end
    end
  end
end
