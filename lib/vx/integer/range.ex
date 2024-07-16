defmodule Vx.Integer.Range do
  @moduledoc false

  @enforce_keys [:range]
  defstruct [:range]

  @type t :: %__MODULE__{range: Range.t()}

  defimpl Vx.Validatable do
    def validate(%{range: range}, value) do
      if value in range do
        :ok
      else
        {:error, "not in range #{inspect(range)}"}
      end
    end
  end
end
