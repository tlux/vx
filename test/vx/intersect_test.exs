defmodule Vx.IntersectTest do
  use ExUnit.Case, async: true

  doctest Vx.Intersect

  describe "t/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.Intersect.t([Vx.String.t(), "foo"]), "foo")

      assert :ok =
               Vx.validate(
                 Vx.Intersect.t([
                   Vx.String.length(min: 2),
                   Vx.String.length(max: 4)
                 ]),
                 "foo"
               )
    end

    test "no match" do
      assert {:error, [error]} =
               Vx.validate(
                 Vx.Intersect.t([Vx.String.t(), Vx.Number.t()]),
                 "foo"
               )

      assert Exception.message(error) == "is no number"

      assert {:error, [error]} =
               Vx.validate(Vx.Intersect.t([Vx.String.t(), "bar"]), "foo")

      assert Exception.message(error) == "is no number"

      assert {:error, errors} =
               Vx.validate(
                 Vx.Intersect.t([
                   Vx.String.length(min: 1),
                   Vx.String.length(max: 2)
                 ]),
                 "foo"
               )

      assert Exception.message(error) ==
               "must be all of (string(min_length=1) & string(max_length=2))"
    end

    test "disallow single item" do
      assert_raise FunctionClauseError, fn ->
        Vx.Intersect.t([Vx.Integer.t()])
      end
    end
  end
end
