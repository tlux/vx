defmodule Vx.IntegerTest do
  use ExUnit.Case, async: true

  describe "t/0" do
    test "match" do
      assert :ok = Vx.validate(Vx.Integer.t(), 123)
    end

    test "no match" do
      Enum.each([123.0, 123.4, "foo", :foo, true, false], fn value ->
        assert {:error, _} = Vx.validate(Vx.Integer.t(), value)
      end)
    end
  end
end
