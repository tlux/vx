defmodule Vx.String do
  @moduledoc """
  The String type.
  """

  use Vx.Type, :string

  @doc """
  Builds a new String type.

  ## Examples

      iex> Vx.String.t() |> Vx.validate!("foo")
      :ok

      iex> Vx.String.t() |> Vx.validate!(123)
      ** (Vx.Error) must be a string
  """
  @spec t() :: t
  def t do
    new(fn value ->
      if is_binary(value) && String.valid?(value) do
        :ok
      else
        {:error, "must be a string"}
      end
    end)
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
  @spec present(t) :: t
  def present(%__MODULE__{} = schema \\ t()) do
    constrain(schema, :present, fn value ->
      if String.trim(value) != "" do
        :ok
      else
        {:error, "must be present"}
      end
    end)
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
  @spec non_empty(t) :: t
  def non_empty(%__MODULE__{} = schema \\ t()) do
    constrain(schema, :non_empty, fn value ->
      if value != "" do
        :ok
      else
        {:error, "must not be empty"}
      end
    end)
  end

  @doc """
  Requires a string to be at least `length` characters long.

  ## Examples

      iex> Vx.String.t() |> Vx.String.min_length(3) |> Vx.validate!("foo")
      :ok

      iex> Vx.String.t() |> Vx.String.min_length(3) |> Vx.validate!("foob")
      :ok

      iex> Vx.String.t() |> Vx.String.min_length(3) |> Vx.validate!("fo")
      ** (Vx.Error) must be at least 3 characters
  """
  @spec min_length(t, non_neg_integer) :: t
  def min_length(%__MODULE__{} = schema \\ t(), length)
      when is_integer(length) and length >= 0 do
    constrain(schema, :min_length, length, fn value ->
      if String.length(value) >= length do
        :ok
      else
        {:error, "must be at least #{length} characters"}
      end
    end)
  end

  @doc """
  Requires a string to be at most `length` characters long.

  ## Examples

      iex> Vx.String.t() |> Vx.String.max_length(3) |> Vx.validate!("foo")
      :ok

      iex> Vx.String.t() |> Vx.String.max_length(3) |> Vx.validate!("fo")
      :ok

      iex> Vx.String.t() |> Vx.String.max_length(3) |> Vx.validate!("fooo")
      ** (Vx.Error) must be at most 3 characters
  """
  @spec max_length(t, non_neg_integer) :: t
  def max_length(%__MODULE__{} = schema \\ t(), length)
      when is_integer(length) and length >= 0 do
    constrain(schema, :max_length, length, fn value ->
      if String.length(value) <= length do
        :ok
      else
        {:error, "must be at most #{length} characters"}
      end
    end)
  end

  @doc """
  Requires a string to match the given regex.

  ## Examples

      iex> Vx.String.t() |> Vx.String.format(~r/\\d+/) |> Vx.validate!("123")
      :ok

      iex> Vx.String.t() |> Vx.String.format(~r/\\d+/) |> Vx.validate!("foo")
      ** (Vx.Error) must match expected format
  """
  @spec format(t, Regex.t()) :: t
  def format(%__MODULE__{} = schema \\ t(), regex) do
    constrain(schema, :format, regex, fn value ->
      if Regex.match?(regex, value) do
        :ok
      else
        {:error, "must match expected format"}
      end
    end)
  end
end
