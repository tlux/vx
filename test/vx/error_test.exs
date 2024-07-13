defmodule Vx.ErrorTest do
  use ExUnit.Case, async: true

  describe "new/2" do
    test "builds a new error" do
      assert Vx.Error.new(Vx.Any.t(), 123) == %Vx.Error{
               schema: Vx.Any.t(),
               actual_value: 123
             }
    end
  end

  describe "new/3" do
    test "custom message" do
      assert Vx.Error.new(Vx.Any.t(), 123, "foo") == %Vx.Error{
               schema: Vx.Any.t(),
               actual_value: 123,
               message: "foo"
             }
    end

    test "custom path" do
      assert Vx.Error.new(Vx.Any.t(), 123, ["foo"]) == %Vx.Error{
               schema: Vx.Any.t(),
               actual_value: 123,
               path: ["foo"]
             }
    end
  end

  describe "new/4" do
    test "custom message and path" do
      assert Vx.Error.new(Vx.Any.t(), 123, ["bar"], "foo") == %Vx.Error{
               schema: Vx.Any.t(),
               actual_value: 123,
               message: "foo",
               path: ["bar"]
             }
    end
  end

  describe "prepend_path/2" do
    test "with existing path" do
      error = Vx.Error.new(Vx.Any.t(), 123, ["foo", "bar"])

      assert %Vx.Error{path: ["baz", "foo", "bar"]} =
               Vx.Error.prepend_path(error, "baz")

      assert %Vx.Error{path: ["baz", "boom", "foo", "bar"]} =
               Vx.Error.prepend_path(error, ["baz", "boom"])
    end

    test "without existing path" do
      error = Vx.Error.new(Vx.Any.t(), 123)

      assert %Vx.Error{path: ["foo"]} = Vx.Error.prepend_path(error, "foo")

      assert %Vx.Error{path: ["foo", "bar"]} =
               Vx.Error.prepend_path(error, ["foo", "bar"])
    end
  end
end
