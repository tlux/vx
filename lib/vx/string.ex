defmodule Vx.String do
  use Vx.Type, :string

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

  @spec present(t) :: t
  def present(%__MODULE__{} = type \\ t()) do
    constrain(type, :present, fn value ->
      if String.trim(value) != "" do
        :ok
      else
        {:error, "must be present"}
      end
    end)
  end

  @spec non_empty(t) :: t
  def non_empty(%__MODULE__{} = type \\ t()) do
    constrain(type, :non_empty, fn value ->
      if value != "" do
        :ok
      else
        {:error, "must not be empty"}
      end
    end)
  end

  @spec min_length(t, non_neg_integer) :: t
  def min_length(%__MODULE__{} = type \\ t(), length)
      when is_integer(length) and length >= 0 do
    constrain(type, :min_length, length, fn value ->
      if String.length(value) >= length do
        :ok
      else
        {:error, "must be at least #{length} characters"}
      end
    end)
  end

  @spec max_length(t, non_neg_integer) :: t
  def max_length(%__MODULE__{} = type \\ t(), length)
      when is_integer(length) and length >= 0 do
    constrain(type, :max_length, length, fn value ->
      if String.length(value) <= length do
        :ok
      else
        {:error, "must be at most #{length} characters"}
      end
    end)
  end

  @spec format(t, Regex.t()) :: t
  def format(%__MODULE__{} = type \\ t(), regex) do
    constrain(type, :format, regex, fn value ->
      if Regex.match?(regex, value) do
        :ok
      else
        {:error, "must match expected format"}
      end
    end)
  end
end
