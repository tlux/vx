defmodule Vx.StructTest do
  use ExUnit.Case, async: true

  describe "t/0" do
    test "match" do
      assert :ok = Vx.validate(Vx.Struct.t(), %Address{})
      assert :ok = Vx.validate(Vx.Struct.t(), %Country{})
    end

    test "no match" do
      Enum.each([nil, "foo", :foo, true, false], fn value ->
        assert {:error, error} = Vx.validate(Vx.Struct.t(), value)
        assert Exception.message(error) == "must be a struct"
      end)
    end
  end

  describe "t/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.Struct.t(Address), %Address{})
    end

    test "no match" do
      assert {:error, error} = Vx.validate(Vx.Struct.t(Country), %Address{})

      assert Exception.message(error) ==
               "must be a struct of type Country"

      Enum.each([nil, "foo", :foo, true, false], fn value ->
        assert {:error, _} = Vx.validate(Vx.Struct.t(Country), value)
      end)
    end
  end
end
