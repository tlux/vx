defmodule Vx.AnyTest do
  use ExUnit.Case

  describe "t/0" do
    test "match" do
      Enum.each(["foo", :foo, true, false, 123, 123.4], fn value ->
        assert :ok = Vx.validate(Vx.Any.t(), value)
      end)
    end
  end
end
