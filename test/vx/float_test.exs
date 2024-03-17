defmodule Vx.FloatTest do
  use ExUnit.Case, async: true

  describe "t/0" do
    test "match" do
      assert :ok = Vx.validate(Vx.Float.t(), 123.0)
      assert :ok = Vx.validate(Vx.Float.t(), 123.4)
    end

    test "no match" do
      Enum.each([123, "foo", :foo, true, false], fn value ->
        assert {:error, error} = Vx.validate(Vx.Float.t(), value)
        assert Exception.message(error) =~ "must be a float"
      end)
    end
  end
end
