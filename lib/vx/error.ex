defmodule Vx.Error do
  @enforce_keys [:schema, :value, :message]
  defexception [:schema, :value, :message]

  @type t :: %__MODULE__{
          schema: Vx.t(),
          value: any,
          message: String.t()
        }
end
