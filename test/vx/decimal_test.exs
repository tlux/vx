defmodule Vx.DecimalTest do
  use ExUnit.Case, async: true

  describe "t/0" do
    test "match" do
      assert :ok = Vx.validate(Vx.Decimal.t(), Decimal.new("1.23"))
    end

    test "no match" do
      Enum.each([:foo, 123, 123.4, true, "foo", %{}, []], fn value ->
        assert {:error, [error]} = Vx.validate(Vx.Decimal.t(), value)
        assert Exception.message(error) == "expected decimal"
      end)
    end
  end
end
