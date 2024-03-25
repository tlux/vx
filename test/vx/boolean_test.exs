defmodule Vx.BooleanTest do
  use ExUnit.Case, async: true

  doctest Vx.Boolean

  describe "t/0" do
    test "match" do
      Enum.each([true, false], fn value ->
        assert :ok = Vx.validate(Vx.Boolean.t(), value)
      end)
    end

    test "no match" do
      Enum.each([:foo, 123, 123.4, "foo", %{}, []], fn value ->
        assert {:error, error} = Vx.validate(Vx.Boolean.t(), value)
        assert Exception.message(error) == "must be a boolean"
      end)
    end
  end
end
