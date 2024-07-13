defmodule Vx.NotTest do
  use ExUnit.Case, async: true

  doctest Vx.Not

  describe "t/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.Not.t(Vx.Integer.t()), "foo")
      assert :ok = Vx.validate(Vx.Not.t(Vx.String.t()), 123)
    end

    test "no match" do
      assert {:error, [error]} = Vx.validate(Vx.Not.t(Vx.Integer.t()), 123)
      assert Exception.message(error) == "expected not(integer)"

      assert {:error, [error]} = Vx.validate(Vx.Not.t(Vx.String.t()), "123")
      assert Exception.message(error) == "expected not(string)"

      assert {:error, [error]} = Vx.validate(Vx.Not.t(:foo), :foo)
      assert Exception.message(error) == "expected not(:foo)"
    end
  end
end
