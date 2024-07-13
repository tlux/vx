defmodule Vx.String do
  @moduledoc """
  The String type.
  """

  use Vx.ContextualConstrain

  alias __MODULE__.{
    Format,
    Length,
    NonEmpty,
    Present
  }

  defstruct []

  @doc """
  Builds a new String type.

  ## Examples

      iex> Vx.String.t() |> Vx.validate!("foo")
      :ok

      iex> Vx.String.t() |> Vx.validate!(123)
      ** (Vx.Error) must be a string
  """
  @spec t() :: Vx.t()
  def t, do: %__MODULE__{}

  @doc """
  Requires a string to match the given regex.

  ## Examples

      iex> Vx.String.t() |> Vx.String.format(~r/\\d+/) |> Vx.validate!("123")
      :ok

      iex> Vx.String.t() |> Vx.String.format(~r/\\d+/) |> Vx.validate!("foo")
      ** (Vx.Error) must match expected format
  """
  @spec format(Vx.t(), Regex.t()) :: Vx.t()
  def format(schema \\ t(), regex) do
    constrain(schema, %Format{regex: regex})
  end

  @doc """
  Requires a string to have a specific size.
  """
  @doc since: "1.0.0"
  @spec length(Vx.t(), Keyword.t()) :: Vx.t()
  def length(schema \\ t(), opts) do
    constrain(schema, Length.new(opts))
  end

  @doc """
  Requires a string to be non-empty after stripping leading and trailing
  whitespace.

  ## Examples

      iex> Vx.String.t() |> Vx.String.present() |> Vx.validate!("foo")
      :ok

      iex> Vx.String.t() |> Vx.String.present() |> Vx.validate!("")
      ** (Vx.Error) must be present

      iex> Vx.String.t() |> Vx.String.present() |> Vx.validate!("   ")
      ** (Vx.Error) must be present
  """
  @spec present(Vx.t()) :: Vx.t()
  def present(schema \\ t()) do
    constrain(schema, %Present{})
  end

  @doc """
  Requires a string to be non-empty.

  ## Examples

      iex> Vx.String.t() |> Vx.String.non_empty() |> Vx.validate!("foo")
      :ok

      iex> Vx.String.t() |> Vx.String.non_empty() |> Vx.validate!("   ")
      :ok

      iex> Vx.String.t() |> Vx.String.non_empty() |> Vx.validate!("")
      ** (Vx.Error) must not be empty
  """
  @spec non_empty(Vx.t()) :: Vx.t()
  def non_empty(schema \\ t()) do
    constrain(schema, %NonEmpty{})
  end

  defimpl Vx.Validatable do
    def validate(_, value), do: is_binary(value) && String.valid?(value)
  end

  defimpl Vx.Humanizable do
    def humanize(_), do: "string"
  end
end
