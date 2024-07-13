defmodule Vx.NoneTest do
  use ExUnit.Case, async: true

  doctest Vx.None

  describe "t/1" do
    test "no match" do
      Enum.each([nil, 1, "foo", true, false], fn value ->
        assert {:error, [error]} = Vx.validate(Vx.None.t(), value)
        assert Exception.message(error) == "expected none"
      end)
    end
  end
end
