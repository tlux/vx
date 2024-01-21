defmodule Vx.LiteralTest do
  use ExUnit.Case, async: true

  describe "t/1" do
    test "match" do
      Enum.each([nil, :foo, true, false], fn value ->
        assert :ok = Vx.validate(Vx.Literal.t(value), value)
      end)
    end

    test "no match" do
      Enum.each([123, 123.4, "foo", %{}, []], fn value ->
        assert {:error, _} = Vx.validate(Vx.Literal.t(value), "bar")
      end)
    end
  end
end
