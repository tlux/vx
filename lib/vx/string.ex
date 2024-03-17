defmodule Vx.String do
  @moduledoc """
  The String type provides validators for strings.
  """

  use Vx.Type

  @doc """
  Checks whether a value is a string.
  """
  @spec t() :: t
  def t do
    new(
      fn value ->
        is_binary(value) && String.valid?(value)
      end,
      %{},
      "must be a string"
    )
  end

  @doc """
  Checks whether a value is a non-empty string.
  """
  @spec non_empty(t) :: t
  def non_empty(%__MODULE__{} = type \\ t()) do
    add_rule(
      type,
      :non_empty,
      fn
        "" -> false
        _ -> true
      end,
      %{},
      "must be non-empty"
    )
  end

  @doc """
  Checks whether a value is a present string. A string is considered present
  when it is non-empty after all leading and trailing whitespace is removed.
  """
  @spec present(t) :: t
  def present(%__MODULE__{} = type \\ t()) do
    add_rule(type, :present, &(String.trim(&1) != ""), %{}, "must be present")
  end

  @doc """
  Checks whether a value is a string of the given minimum length.
  """
  @spec min_length(t, non_neg_integer) :: t
  def min_length(%__MODULE__{} = type \\ t(), length)
      when is_integer(length) and length >= 0 do
    add_rule(
      type,
      :min_length,
      &(String.length(&1) >= length),
      %{length: length},
      fn actual_value ->
        "must be at least #{length} characters long " <>
          "(was #{String.length(actual_value)})"
      end
    )
  end

  @doc """
  Checks whether a value is a string of the given maximum length.
  """
  @spec max_length(t, non_neg_integer) :: t
  def max_length(%__MODULE__{} = type \\ t(), length)
      when is_integer(length) and length >= 0 do
    add_rule(
      type,
      :max_length,
      &(String.length(&1) <= length),
      %{length: length},
      fn actual_value ->
        "must be at most #{length} characters long " <>
          "(was #{String.length(actual_value)})"
      end
    )
  end

  @doc """
  Checks whether a value matches the given regular expression.
  """
  @spec format(t, Regex.t()) :: t
  def format(%__MODULE__{} = type \\ t(), %Regex{} = regex) do
    add_rule(
      type,
      :format,
      &Regex.match?(regex, &1),
      %{regex: regex},
      "has an unexpected format"
    )
  end
end
