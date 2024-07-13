defmodule Vx.ExceptTest do
  use ExUnit.Case, async: true

  doctest Vx.Except

  describe "t/1" do
    test "chain" do
      assert Vx.Except.t([
               Vx.Number.gt(2),
               Vx.Number.lt(10),
               Vx.Float.t()
             ]) ==
               Vx.Except.t(
                 Vx.Except.t(
                   Vx.Number.gt(2),
                   Vx.Number.lt(10)
                 ),
                 Vx.Float.t()
               )
    end
  end

  describe "t/2" do
    setup do
      {:ok, schema: Vx.Except.t(Vx.Number.t(), Vx.Integer.t())}
    end

    test "match", %{schema: schema} do
      assert :ok = Vx.validate(schema, 123.4)
    end

    test "no match", %{schema: schema} do
      assert {:error, [error]} = Vx.validate(schema, 123)
      assert Exception.message(error) == "expected number except integer"
    end

    test "disallow single item" do
      assert_raise FunctionClauseError, fn ->
        Vx.Except.t([Vx.Integer.t()])
      end
    end
  end
end
