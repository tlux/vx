defmodule Vx.NilTest do
  use ExUnit.Case, async: true

  doctest Vx.Nil

  describe "t/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.Nil.t(), nil)
    end

    test "no match" do
      assert {:error, [error]} = Vx.validate(Vx.Nil.t(), "foo")
      assert Exception.message(error) == "expected nil"
    end
  end
end
