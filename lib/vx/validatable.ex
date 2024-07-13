defprotocol Vx.Validatable do
  @moduledoc """
  The Validatable protocol that is implemented by all types of the `Vx` type
  system.

  As a fallback, any value not having an implementation for the `Vx.Validatable`
  protocol is considered a `Vx.Literal` when passed to `validate/2`.
  """

  @fallback_to_any true

  @type result ::
          boolean
          | :ok
          | :error
          | {:error, Vx.Error.t()}
          | {:error, String.t()}
          | {:error, {Vx.Error.path(), String.t()}}
          | {:error, nonempty_list(Vx.Error.t())}
          | {:error, nonempty_list(String.t())}
          | {:error, nonempty_list({Vx.Error.path(), String.t()})}

  @doc """
  Validates a value against a given validatable.
  """
  @spec validate(t, any) :: result
  def validate(validatable, value)
end

defimpl Vx.Validatable, for: Any do
  def validate(literal, value) do
    literal
    |> Vx.Literal.t()
    |> Vx.Validatable.validate(value)
  end
end
