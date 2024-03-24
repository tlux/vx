defmodule Vx.Enum do
  @moduledoc """
  The Enum type validates a value against a fixed list of values.
  """

  @enforce_keys [:values]
  defstruct [:values]

  @type t :: t(nonempty_list(any))
  @opaque t(values) :: %__MODULE__{values: values}

  @spec t(values) :: t(values) when values: nonempty_list(any)
  def t([_ | _] = values) when is_list(values) do
    %__MODULE__{values: values}
  end

  defimpl Vx.Validatable do
    def validate(%{values: values}, value) do
      if value in values do
        :ok
      else
        {:error, "must be one of #{Vx.Util.inspect_enum(values)}"}
      end
    end
  end

  defimpl Vx.Inspectable do
    def inspect(%{values: values}), do: "enum" <> Kernel.inspect(values)
  end
end
