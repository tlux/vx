defmodule Vx.Schema do
  @moduledoc false

  alias Vx.Validator

  defstruct [:type, validators: []]

  @type t :: t(atom)
  @type t(type) :: %__MODULE__{type: type, validators: [Validator.t()]}

  @spec new(atom, Validator.fun()) :: t
  def new(type, fun) do
    %__MODULE__{type: type, validators: [Validator.new(fun)]}
  end

  @spec validate(t, atom, Validator.fun()) :: t
  def validate(%__MODULE__{validators: validators} = schema, key, fun) do
    %{schema | validators: [Validator.new(key, fun) | validators]}
  end

  @spec eval(t, any) :: :ok | {:error, Vx.TypeError.t()}
  def eval(%__MODULE__{type: type, validators: validators}, value) do
    validators
    |> Enum.reverse()
    |> Enum.reduce_while(:ok, fn validator, _ ->
      case Validator.eval(validator, value) do
        :ok ->
          {:cont, :ok}

        {:error, key} ->
          {:halt, {:error, Vx.TypeError.new(type, key, value)}}
      end
    end)
  end
end
