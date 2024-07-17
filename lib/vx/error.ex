defmodule Vx.Error do
  @moduledoc """
  An error that occurred during schema validation.
  """

  @enforce_keys [:schema, :actual_value]
  defexception [:schema, :actual_value, :message, path: []]

  @type path_segment :: term

  @type path :: [path_segment]

  @type t :: %__MODULE__{
          schema: Vx.t(),
          actual_value: any,
          message: nil | String.t(),
          path: path
        }

  @doc """
  Builds a new error.
  """
  @spec new(Vx.t(), any) :: t
  def new(schema, value) do
    %__MODULE__{schema: schema, actual_value: value}
  end

  @doc """
  Builds a new error with a custom message or path.
  """
  @spec new(Vx.t(), any, path | String.t()) :: t
  def new(schema, value, path_or_message)

  def new(schema, value, path) when is_list(path) do
    %__MODULE__{
      schema: schema,
      actual_value: value,
      path: path
    }
  end

  def new(schema, value, message) when is_binary(message) do
    %__MODULE__{
      schema: schema,
      actual_value: value,
      message: message
    }
  end

  @doc """
  Builds a new error with a custom message and path.
  """
  @spec new(Vx.t(), any, path, String.t()) :: t
  def new(schema, value, path, message)
      when is_list(path) and is_binary(message) do
    %__MODULE__{
      schema: schema,
      actual_value: value,
      message: message,
      path: path
    }
  end

  @impl Exception
  def message(%{path: []} = error), do: get_message(error)

  def message(%{path: path} = error) do
    "#{get_message(error)} at #{inspect(path)}"
  end

  defp get_message(%{schema: schema, message: nil}) do
    "expected #{Vx.Printable.print(schema)}"
  end

  defp get_message(%{message: message}), do: message

  @doc """
  Prepends a path to the error path.
  """
  @spec prepend_path(t, path | path_segment) :: t
  def prepend_path(%__MODULE__{} = error, path) when is_list(path) do
    %{error | path: path ++ error.path}
  end

  def prepend_path(%__MODULE__{} = error, segment) do
    %{error | path: [segment | error.path]}
  end

  @doc """
  Puts a new schema in the error.
  """
  @spec put_schema(t, Vx.t()) :: t
  def put_schema(error, schema) do
    %{error | schema: schema}
  end
end
