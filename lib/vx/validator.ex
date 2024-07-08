defmodule Vx.Validator do
  @moduledoc """
  The Validator type provides a function to validate a value with.
  """

  @enforce_keys [:fun]
  defstruct [:fun]

  @type fun ::
          (any ->
             boolean
             | :ok
             | :error
             | {:error, String.t()}
             | {:error, [String.t()]})

  @type t :: %__MODULE__{fun: fun}

  @spec t(fun) :: Vx.t()
  def t(fun), do: %__MODULE__{fun: fun}

  defimpl Vx.Validatable do
    def validate(schema, value) do
      case schema.fun.(value) do
        true ->
          []

        :ok ->
          []

        {:error, message_or_messages} ->
          message_or_messages
          |> List.wrap()
          |> Enum.map(&Vx.Error.new(schema, value, &1))

        _ ->
          Vx.Error.new(schema, value, "is invalid")
      end
    end
  end
end
