defmodule Vx.IntegerTest do
  use ExUnit.Case, async: true

  doctest Vx.Integer

  describe "t/0" do
    test "match" do
      assert :ok = Vx.validate(Vx.Integer.t(), 123)
    end

    test "no match" do
      Enum.each([123.0, 123.4, "foo", :foo, true, false], fn value ->
        assert {:error, error} = Vx.validate(Vx.Integer.t(), value)
        assert Exception.message(error) =~ "must be an integer"
      end)
    end
  end
end
