defmodule Vx.Error do
  @moduledoc """
  An error that occurred during schema validation.
  """

  @enforce_keys [:caused_by, :actual_value]
  defexception [:caused_by, :actual_value, :message, path: []]

  @type path_segment :: term

  @type path :: [path_segment]

  @type t :: %__MODULE__{
          caused_by: Vx.t(),
          actual_value: any,
          message: nil | String.t(),
          path: path
        }

  @spec new(Vx.t(), any) :: t
  def new(caused_by, value) do
    %__MODULE__{
      caused_by: caused_by,
      actual_value: value
    }
  end

  @spec new(Vx.t(), any, path | String.t()) :: t
  def new(caused_by, value, path_or_message)

  def new(caused_by, value, path) when is_list(path) do
    %__MODULE__{
      caused_by: caused_by,
      actual_value: value,
      path: path
    }
  end

  def new(caused_by, value, message) when is_binary(message) do
    %__MODULE__{
      caused_by: caused_by,
      actual_value: value,
      message: message
    }
  end

  @spec new(Vx.t(), any, path, String.t()) :: t
  def new(caused_by, value, path, message)
      when is_list(path) and is_binary(message) do
    %__MODULE__{
      caused_by: caused_by,
      actual_value: value,
      message: message,
      path: path
    }
  end

  @impl true
  def message(%{path: [], message: nil}), do: "invalid"

  def message(%{path: path, message: nil}) do
    "value at #{inspect(path)} invalid"
  end

  def message(%{path: [], message: message}), do: message

  def message(%{path: path, message: message}) do
    "value at #{inspect(path)} #{message}"
  end

  @doc """
  Prepends a message to the error message.
  """
  @spec prepend_message(t, String.t()) :: t
  def prepend_message(%__MODULE__{} = error, message) do
    %{error | message: "#{message}: #{error.message}"}
  end

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
end
