defmodule Vx.Schema do
  @moduledoc false

  alias Vx.Validator

  defstruct [:type, validators: []]

  @type schema_type :: atom | {atom, any}
  @type t :: t(schema_type)
  @type t(type) :: %__MODULE__{type: type, validators: [Validator.t()]}

  @spec new(schema_type) :: t
  def new(type) do
    %__MODULE__{type: type, validators: []}
  end

  @spec new(schema_type, Validator.fun()) :: t
  def new(type, fun) do
    %__MODULE__{type: type, validators: [Validator.new(type, fun)]}
  end

  @spec any_of([t]) :: t
  def any_of([]), do: new({:any_of, []})

  def any_of(schemata) when is_list(schemata) do
    new({:any_of, schemata}, fn value ->
      Enum.reduce_while(schemata, :error, fn
        %__MODULE__{} = schema, _ ->
          case eval(schema, value) do
            :ok -> {:halt, :ok}
            {:error, error} -> {:cont, error}
          end

        _, _ ->
          raise ArgumentError,
                "any_of/1 must be passed a list of #{inspect(__MODULE__)}"
      end)
    end)
  end

  @spec validate(t, Validator.validator_type(), Validator.fun()) :: t
  def validate(
        %__MODULE__{type: type, validators: validators} = schema,
        key,
        fun
      ) do
    %{schema | validators: [Validator.new(type, key, fun) | validators]}
  end

  @spec eval(t, any) :: :ok | {:error, Vx.TypeError.t()}
  def eval(%__MODULE__{validators: validators}, value) do
    validators
    |> Enum.reverse()
    |> Enum.reduce_while(:ok, fn validator, _ ->
      case Validator.eval(validator, value) do
        :ok -> {:cont, :ok}
        error -> {:halt, error}
      end
    end)
  end
end
