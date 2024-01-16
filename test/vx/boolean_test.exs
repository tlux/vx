defmodule Vx.BooleanTest do
  use ExUnit.Case, async: true

  describe "t/0" do
    test "match" do
      Enum.each([true, false], fn value ->
        assert :ok = Vx.validate(Vx.Boolean.t(), value)
      end)
    end

    test "no match" do
      Enum.each([:foo, 123, 123.4, "foo", %{}, []], fn value ->
        assert {:error, _} = Vx.validate(Vx.Boolean.t(), value)
      end)
    end
  end
end
