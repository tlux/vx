defmodule Vx.FloatTest do
  use ExUnit.Case, async: true

  test "t/0" do
    assert :ok = Vx.validate(Vx.Float.t(), 123.0)
    assert :ok = Vx.validate(Vx.Float.t(), 123.4)

    Enum.each([123, "foo", :foo, true, false], fn value ->
      assert {:error, _} = Vx.validate(Vx.Float.t(), value)
    end)
  end
end
