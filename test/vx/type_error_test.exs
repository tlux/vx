defmodule Vx.TypeErrorTest do
  use ExUnit.Case

  alias Vx.TypeError

  test "unwrap/1" do
    error =
      TypeError.wrap(
        TypeError.new(:map, :shape, %{}),
        TypeError.new(:string, :present, "  ")
      )

    assert error.inner == TypeError.new(:string, :present, "  ")
  end

  describe "message/1" do
    test "message without validator name" do
      assert Exception.message(TypeError.new(:string, "foo")) ==
               "Type error (string): #{inspect("foo")}"
    end

    test "message with validator name" do
      assert Exception.message(TypeError.new(:string, :invalid, "foo")) ==
               "Type error (string): #{inspect("foo")} (validator: invalid)"
    end

    test "message with wrapped error" do
      value_1 = %{"foo" => %{"bar" => "  "}}
      value_2 = %{"bar" => "  "}
      value_3 = "  "

      assert Exception.message(
               TypeError.wrap(
                 TypeError.new(:map, :shape, value_1),
                 TypeError.wrap(
                   TypeError.new(:map, :shape, value_2),
                   TypeError.new(:string, :present, value_3)
                 )
               )
             ) ==
               "Type error (map): #{inspect(value_1)} (validator: shape)\n" <>
                 "  Type error (map): #{inspect(value_2)} (validator: shape)\n" <>
                 "    Type error (string): #{inspect(value_3)} (validator: present)"
    end
  end
end
