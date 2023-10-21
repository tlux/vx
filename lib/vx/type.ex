defmodule Vx.Type do
  alias Vx.Validators

  defmacro __using__(_) do
    quote do
      defstruct [:validators]

      @opaque t :: %__MODULE__{validators: Validators.t()}

      defp init do
        %__MODULE__{validators: Validators.new(__MODULE__)}
      end

      defp init(fun, details \\ %{}) do
        %__MODULE__{validators: Validators.new(__MODULE__, fun, details)}
      end

      defp validate(type, name, fun, details \\ %{}) do
        %{
          type
          | validators: Validators.add(type.validators, name, fun, details)
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
