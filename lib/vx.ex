defmodule Vx do
  @moduledoc """
  Vx is a schema validation library.
  """

  alias Vx.{Error, Validatable}

  @typedoc """
  A Vx schema is anything that implements the `Vx.Validatable` protocol.
  """
  @type schema :: Validatable.t()

  @doc """
  Validates a value against a given schema.

  ## Examples

      iex> Vx.validate(Vx.String.t(), "foo")
      :ok

      iex> Vx.validate(Vx.String.t(), 123)
      {:error, %Vx.Error{message: "must be a string", schema: Vx.String.t(), value: 123}}
  """
  @spec validate(schema, any) :: :ok | {:error, Error.t()}
  def validate(schema, value) do
    case Validatable.validate(schema, value) do
      :ok ->
        :ok

      {:error, message} ->
        {:error, %Error{schema: schema, value: value, message: message}}
    end
  end

  @doc """
  Validates a value against a given schema. Raises on error.

  ## Examples

      iex> Vx.validate!(Vx.String.t(), "foo")
      :ok

      iex> Vx.validate!(Vx.String.t(), 123)
      ** (Vx.Error) must be a string
  """
  @spec validate!(schema, any) :: :ok | no_return
  def validate!(schema, value) do
    with {:error, error} <- validate(schema, value) do
      raise error
    end
  end

  @doc """
  Checks if a value is valid against a given schema.

  ## Examples

      iex> Vx.valid?(Vx.String.t(), "foo")
      true

      iex> Vx.valid?(Vx.String.t(), 123)
      false
  """
  @doc since: "0.4.0"
  @spec valid?(schema, any) :: boolean
  def valid?(schema, value) do
    validate(schema, value) == :ok
  end
end
