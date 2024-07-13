defmodule Vx do
  @moduledoc """
  Vx is a schema validation library.
  """

  @typedoc """
  A `Vx` schema is anything that implements the `Vx.Validatable` protocol.
  """
  @type t :: Vx.Validatable.t()

  @doc """
  Validates a value against a given schema.

  ## Examples

      iex> Vx.validate(Vx.String.t(), "foo")
      :ok

      iex> Vx.validate(Vx.String.t(), 123)
      {:error, [Vx.Error.new(Vx.String.t(), 123)]}
  """
  @spec validate(t, any) :: :ok | {:error, [Vx.Error.t()]}
  def validate(schema, value) do
    case errors_on(schema, value) do
      [] -> :ok
      errors -> {:error, errors}
    end
  end

  @doc """
  Validates the schema returning a list of errors.
  """
  @doc since: "1.0.0"
  @spec errors_on(t, any) :: [Vx.Error.t()]
  def errors_on(schema, value) do
    case Vx.Validatable.validate(schema, value) do
      res when res in [true, :ok] ->
        []

      res when res in [false, :error] ->
        [Vx.Error.new(schema, value)]

      {:error, errors} when is_list(errors) ->
        Enum.map(errors, &map_error(schema, value, &1))

      {:error, error} ->
        [map_error(schema, value, error)]
    end
  end

  defp map_error(_schema, _value, %Vx.Error{} = error), do: error

  defp map_error(schema, value, message) when is_binary(message) do
    Vx.Error.new(schema, value, message)
  end

  defp map_error(schema, value, {path, message})
       when is_binary(message) and is_list(path) do
    Vx.Error.new(schema, value, path, message)
  end

  @doc """
  Returns the list of error messages for a given schema and value.
  """
  @doc since: "1.0.0"
  @spec error_messages_on(t, any) :: [String.t()]
  def error_messages_on(schema, value) do
    schema
    |> errors_on(value)
    |> Enum.map(&Vx.Error.message/1)
  end

  @doc """
  Validates a value against a given schema. Raises on error.

  ## Examples

      iex> Vx.validate!(Vx.String.t(), "foo")
      :ok

      iex> Vx.validate!(Vx.String.t(), 123)
      ** (Vx.ValidationFailedError) Validation failed: expected string
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
