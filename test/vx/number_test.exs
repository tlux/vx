defmodule Vx.NumberTest do
  use ExUnit.Case, async: true

  test "t/0" do
    assert :ok = Vx.validate(Vx.Number.t(), 123)
    assert :ok = Vx.validate(Vx.Number.t(), 123.0)
    assert :ok = Vx.validate(Vx.Number.t(), 123.4)

    Enum.each(["foo", :foo, true, false], fn value ->
      assert {:error, _} = Vx.validate(Vx.Number.t(), value)
    end)
  end
end
