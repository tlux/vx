defmodule Vx.Validation do
  alias Vx.{Validatable2, ValidationError, Validator}

  @spec validate(Validatable2.t(), any()) ::
          :ok | {:error, ValidationError.t()}
  def validate(type, value) do
    with :ok <- validate_type(type, value) do
      validate_rules(type, value)
    end
  end

  @spec validate_type(Validatable2.t(), any()) ::
          :ok | {:error, ValidationError.t()}
  def validate_type(validatable, value) do
    case Validatable2.type(validatable) do
      nil -> :ok
      validator -> Validator.run(validator, value)
    end
  end

  @spec validate_rules(Validatable2.t(), any()) ::
          :ok | {:error, ValidationError.t()}
  def validate_rules(validatable, value) do
    validatable
    |> Validatable2.rules()
    |> Enum.reduce_while(:ok, fn validator, _ ->
      case Validator.run(validator, value) do
        :ok -> {:cont, :ok}
        error -> {:halt, error}
      end
    end)
  end
end
