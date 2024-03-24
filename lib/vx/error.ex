defmodule Vx.Error do
  @moduledoc """
  An error that is returned or raised when validation fails.
  """

  @enforce_keys [:schema, :value, :message]
  defexception [:schema, :value, :message]

  @type t :: %__MODULE__{
          schema: Vx.t(),
          value: any,
          message: String.t()
        }
end
