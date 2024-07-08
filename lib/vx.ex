defmodule Vx do
  @moduledoc """
  Vx is a schema validation library.
  """

  @typedoc """
  A Vx schema is anything that implements the `Vx.Validatable` protocol.
  """
  @type t :: Vx.Validatable.t()

  @doc """
  Validates a value against a given schema.

  ## Examples

      iex> Vx.validate(Vx.String.t(), "foo")
      :ok

      iex> Vx.validate(Vx.String.t(), 123)
      {:error, VxError.new(Vx.String.t(), 123, "must be a string")}
  """
  @spec validate(t, any) :: :ok | {:error, [Vx.Error.t()]}
  def validate(schema, value) do
    case Vx.Validatable.validate(schema, value) do
      [] -> :ok
      errors -> {:error, Enum.sort_by(errors, & &1.path)}
    end
  end

  @doc """
  Validates a value against a given schema. Raises on error.

  ## Examples

      iex> Vx.validate!(Vx.String.t(), "foo")
      :ok

      iex> Vx.validate!(Vx.String.t(), 123)
      ** (Vx.ValidationFailedError) Validation failed
  """
  @spec validate!(t, any) :: :ok | no_return
  def validate!(schema, value) do
    with {:error, errors} <- validate(schema, value) do
      raise Vx.ValidationFailedError.new(errors)
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
  @spec valid?(t, any) :: boolean
  def valid?(schema, value) do
    validate(schema, value) == :ok
  end
end
