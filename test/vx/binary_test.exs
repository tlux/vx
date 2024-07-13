defmodule Vx.BinaryTest do
  use ExUnit.Case, async: true

  doctest Vx.Binary

  describe "t/0" do
    test "match" do
      Enum.each(["foo", <<0, 1, 2>>], fn value ->
        assert :ok = Vx.validate(Vx.Binary.t(), value)
      end)
    end

    test "no match" do
      Enum.each([:foo, 123, 123.4, ~c"char", %{}, []], fn value ->
        assert {:error, [error]} = Vx.validate(Vx.Binary.t(), value)
        assert Exception.message(error) == "expected binary"
      end)
    end
  end
end
