defmodule Vx.AnyTest do
  use ExUnit.Case, async: true

  describe "t/0" do
    test "match" do
      Enum.each(["foo", :foo, true, false, 123, 123.4], fn value ->
        assert :ok = Vx.validate(Vx.Any.t(), value)
      end)
    end
  end

  describe "eq/1" do
    test "match" do
      assert Vx.valid?(Vx.Any.eq("foo"), "foo")
    end

    test "no match" do
      refute Vx.valid?(Vx.Any.eq("foo"), "bar")
    end
  end

  describe "eq/2" do
    test "match" do
      assert Vx.valid?(Vx.Any.eq(Vx.Any.t(), "foo"), "foo")
      assert Vx.valid?(Vx.Any.eq(Vx.String.t(), "foo"), "foo")
    end

    test "no match" do
      refute Vx.valid?(Vx.Any.eq(Vx.String.t(), "foo"), "bar")
      refute Vx.valid?(Vx.Any.eq(Vx.Integer.t(), "foo"), "foo")
    end
  end

  describe "of/1" do
    test "match" do
      assert Vx.valid?(Vx.Any.of(["foo", "bar"]), "foo")
    end

    test "no match" do
      refute Vx.valid?(Vx.Any.of(["foo", "bar"]), "baz")
    end
  end

  describe "of/2" do
    test "match" do
      assert Vx.valid?(Vx.Any.of(Vx.Any.t(), ["foo", "bar"]), "foo")
      assert Vx.valid?(Vx.Any.of(Vx.String.t(), ["foo", "bar"]), "foo")
    end

    test "no match" do
      refute Vx.valid?(Vx.Any.of(Vx.String.t(), ["foo", "bar"]), "baz")
      refute Vx.valid?(Vx.Any.of(Vx.Integer.t(), ["foo", "bar"]), "foo")
    end
  end
end
