defmodule Vx.IntersectTest do
  use ExUnit.Case, async: true

  doctest Vx.Intersect

  describe "t/2" do
    test "match" do
      assert :ok = Vx.validate(Vx.Intersect.t(Vx.String.t(), "foo"), "foo")

      assert :ok =
               Vx.validate(
                 Vx.Intersect.t(
                   Vx.String.length(min: 2),
                   Vx.String.length(max: 4)
                 ),
                 "foo"
               )
    end

    test "no match" do
      assert {:error, [error]} =
               Vx.validate(
                 Vx.Intersect.t(Vx.String.t(), Vx.Number.t()),
                 "foo"
               )

      assert Exception.message(error) == "expected string and number"

      assert {:error, [error]} =
               Vx.validate(Vx.Intersect.t([Vx.String.t(), "bar"]), "foo")

      assert Exception.message(error) == ~s[expected string and "bar"]

      assert {:error, [error]} =
               Vx.validate(
                 Vx.Intersect.t(
                   Vx.String.length(min: 1),
                   Vx.String.length(max: 2)
                 ),
                 "foo"
               )

      assert Exception.message(error) ==
               ~s(expected string[size >= 1] and string[size <= 2])
    end

    test "disallow single item" do
      assert_raise FunctionClauseError, fn ->
        Vx.Intersect.t([Vx.Integer.t()])
      end
    end
  end
end
