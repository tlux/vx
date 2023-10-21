defmodule Vx.String do
  use Vx.Type

  @spec t() :: t
  def t do
    init(&String.valid?/1)
  end

  @spec non_empty(t) :: t
  def non_empty(%__MODULE__{} = type \\ t()) do
    validate(type, :non_empty, fn
      "" -> false
      _ -> true
    end)
  end

  @spec present(t) :: t
  def present(%__MODULE__{} = type \\ t()) do
    validate(type, :present, &(String.trim(&1) != ""))
  end

  @spec min_length(t, non_neg_integer) :: t
  def min_length(%__MODULE__{} = type \\ t(), length)
      when is_integer(length) and length >= 0 do
    validate(
      type,
      :min_length,
      &(String.length(&1) >= length),
      %{length: length}
    )
  end

  @spec max_length(t, non_neg_integer) :: t
  def max_length(%__MODULE__{} = type \\ t(), length)
      when is_integer(length) and length >= 0 do
    validate(
      type,
      :max_length,
      &(String.length(&1) <= length),
      %{length: length}
    )
  end

  @spec format(t, Regex.t()) :: t
  def format(%__MODULE__{} = type \\ t(), %Regex{} = regex) do
    validate(type, :format, &Regex.match?(regex, &1), %{regex: regex})
  end
end
