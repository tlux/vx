defmodule Vx.Schema do
  @moduledoc false

  alias Vx.Validator

  defstruct [:name, validators: []]

  @type name :: atom
  @type t :: t(name)
  @type t(name) :: %__MODULE__{name: name, validators: [Validator.t()]}

  @doc """
  Builds a new schema with the given name without any validators attached.
  """
  @spec new(name) :: t
  def new(name) do
    %__MODULE__{name: name, validators: []}
  end

  @doc """
  Builds a new schema with the given name and default validator.
  """
  @spec new(name, Validator.fun(), Validator.details()) :: t
  def new(name, fun, details \\ %{}) do
    %__MODULE__{
      name: name,
      validators: [Validator.new(name, nil, fun, details)]
    }
  end

  @doc """
  Composes multiple schemata into a single schema.
  """
  @spec union([t]) :: t
  def union([]), do: new(:union)

  def union(schemata) when is_list(schemata) do
    unless schema_list?(schemata) do
      raise ArgumentError,
            "union/1 must be passed a list of #{inspect(__MODULE__)}"
    end

    do_union(schemata)
  end

  @spec union(t, t) :: t
  def union(%__MODULE__{} = schema, %__MODULE__{} = other) do
    do_union([schema, other])
  end

  defp do_union(schemata) do
    new(
      :union,
      fn value ->
        Enum.reduce_while(schemata, :error, fn schema, _ ->
          case eval(schema, value) do
            :ok -> {:halt, :ok}
            {:error, error} -> {:cont, error}
          end
        end)
      end,
      %{schemata: schemata}
    )
  end

  @spec intersect([t]) :: t
  def intersect(schemata) when is_list(schemata) do
    unless schema_list?(schemata) do
      raise ArgumentError,
            "intersect/1 must be passed a list of #{inspect(__MODULE__)}"
    end

    do_intersect(schemata)
  end

  @spec intersect(t, t) :: t
  def intersect(%__MODULE__{} = schema, %__MODULE__{} = other) do
    do_intersect([schema, other])
  end

  defp do_intersect(schemata) do
    new(
      :intersect,
      fn value ->
        Enum.reduce_while(schemata, :error, fn schema, _ ->
          case eval(schema, value) do
            :ok -> {:cont, :ok}
            {:error, error} -> {:halt, error}
          end
        end)
      end,
      %{schemata: schemata}
    )
  end

  defp schema_list?(elements) when is_list(elements) do
    Enum.all?(elements, &match?(%__MODULE__{}, &1))
  end

  @doc """
  Adds a custom validator to the schema.
  """
  @spec validate(t, Validator.name(), Validator.fun(), Validator.details()) :: t
  def validate(
        %__MODULE__{name: schema_name, validators: validators} = schema,
        name,
        fun,
        details \\ %{}
      ) do
    %{
      schema
      | validators: [
          Validator.new(schema_name, name, fun, details) | validators
        ]
    }
  end

  @doc """
  Validates whether the value matches the schema or the values are equal.
  """
  @spec eval(t | value, value) :: :ok | {:error, Vx.ValidationError.t()}
        when value: var
  def eval(schema, value)

  def eval(%__MODULE__{validators: []}, _value), do: :ok

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

  def eval(value, actual_value) do
    value
    |> Vx.Any.eq()
    |> eval(actual_value)
  end

  @doc """
  Validates the schema. Raises on error.
  """
  @spec eval!(t, any) :: :ok | no_return
  def eval!(%__MODULE__{} = schema, value) do
    with {:error, error} <- eval(schema, value) do
      raise error
    end
  end

  @doc """
  Validates the schema and returns a boolean.
  """
  @spec valid?(t, any) :: boolean()
  def valid?(%__MODULE__{} = schema, value) do
    match?(:ok, eval(schema, value))
  end
end
