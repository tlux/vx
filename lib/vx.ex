defmodule Vx do
  @moduledoc """
  Vx is a schema validation library for Elixir.
  """

  alias Vx.{Error, Validatable}

  @type t :: Validatable.t()

  @doc """
  Validates a value against a given schema.
  """
  @spec validate(t, any) :: :ok | {:error, Error.t()}
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
  """
  @spec validate!(t, any) :: :ok | no_return
  def validate!(schema, value) do
    with {:error, error} <- validate(schema, value) do
      raise error
    end
  end
end
