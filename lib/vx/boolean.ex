defmodule Vx.Boolean do
  @moduledoc """
  The Boolean type.
  """

  use Vx.Type, :boolean

  @doc """
  Builds a new Boolean type.

  ## Examples

      iex> Vx.Boolean.t() |> Vx.validate!(true)
      :ok

      iex> Vx.Boolean.t() |> Vx.validate!(false)
      :ok

      iex> Vx.Boolean.t() |> Vx.validate!("foo")
      ** (Vx.Error) must be a boolean
  """
  @spec t() :: t
  def t do
    new(fn
      value when is_boolean(value) -> :ok
      _ -> {:error, "must be a boolean"}
    end)
  end
end
