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

      shape = %{"foo" => "bar"}

      assert Schema.eval(Vx.Map.shape(shape), invalid_value) ==
               {:error, Vx.TypeError.new(:map, {:shape, shape}, invalid_value)}
    end

    test "schema value" do
      assert Schema.eval(Vx.Map.shape(%{"foo" => Vx.String.t()}), %{
               "foo" => "bar"
             }) == :ok

      invalid_value = %{"foo" => "  "}
      shape = %{"foo" => Vx.String.present()}

      assert Schema.eval(Vx.Map.shape(shape), invalid_value) ==
               {:error,
                Vx.TypeError.wrap(
                  Vx.TypeError.new(:map, {:shape, shape}, invalid_value),
                  Vx.TypeError.new(:string, :present, "  ")
                )}
    end

    test "schema key" do
      shape = %{Vx.String.t() => "bar"}

      assert Schema.eval(Vx.Map.shape(shape), %{"foo" => "bar", "bar" => 123}) ==
               :ok

      invalid_value = %{foo: "  "}

      assert Schema.eval(Vx.Map.shape(shape), invalid_value) ==
               {:error,
                Vx.TypeError.wrap(
                  Vx.TypeError.new(:map, {:shape, shape}, invalid_value),
                  Vx.TypeError.new(:string, :present, "  ")
                )}
    end

    test "schema key and value" do
      shape = %{Vx.String.t() => Vx.String.t()}

      assert Schema.eval(Vx.Map.shape(shape), %{"foo" => "bar"}) == :ok

      invalid_value = %{"foo" => "bar", "bar" => 123}

      assert Schema.eval(Vx.Map.shape(shape), invalid_value) ==
               {:error,
                Vx.TypeError.wrap(
                  Vx.TypeError.new(:map, {:shape, shape}, invalid_value),
                  Vx.TypeError.new(:string, :present, "  ")
                )}
    end
  end
end
