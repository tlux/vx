defmodule Vx.MapTest do
  use ExUnit.Case, async: true

  alias Vx.Schema

  @invalid ["", <<0xFFFF::16>>, nil, :foo, true, false, 123, []]

  test "t/0" do
    assert Schema.eval(Vx.Map.t(), %{}) == :ok
    assert Schema.eval(Vx.Map.t(), %{"foo" => "bar"}) == :ok

    Enum.each(@invalid, fn value ->
      assert Schema.eval(Vx.Map.t(), value) ==
               {:error, Vx.TypeError.new(:map, nil, value)}
    end)
  end

  describe "shape/1" do
    test "exact key and value" do
      assert Schema.eval(Vx.Map.shape(%{"foo" => "bar"}), %{
               "foo" => "bar"
             }) == :ok

      invalid_value = %{"foo" => "baz"}

      assert Schema.eval(Vx.Map.shape(%{"foo" => "bar"}), invalid_value) ==
               {:error, Vx.TypeError.new(:map, :shape, invalid_value)}
    end

    test "schema value" do
      assert Schema.eval(Vx.Map.shape(%{"foo" => Vx.String.t()}), %{
               "foo" => "bar"
             }) == :ok

      invalid_value = %{"foo" => "  "}

      assert Schema.eval(
               Vx.Map.shape(%{"foo" => Vx.String.present()}),
               invalid_value
             ) ==
               {:error,
                Vx.TypeError.wrap(
                  Vx.TypeError.new(:map, :shape, invalid_value),
                  Vx.TypeError.new(:string, :present, "  ")
                )}
    end

    test "schema key" do
      assert Schema.eval(
               Vx.Map.shape(%{Vx.String.t() => "bar"}),
               %{"foo" => "bar"}
             ) == :ok

      invalid_value = %{foo: "  "}

      assert Schema.eval(
               Vx.Map.shape(%{Vx.String.t() => "bar"}),
               invalid_value
             ) ==
               {:error,
                Vx.TypeError.wrap(
                  Vx.TypeError.new(:map, :shape, invalid_value),
                  Vx.TypeError.new(:string, :present, "  ")
                )}
    end
  end
end
