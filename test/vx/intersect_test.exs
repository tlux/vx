defmodule Vx.IntersectTest do
  use ExUnit.Case, async: true

  describe "t/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.Intersect.t([Vx.String.t()]), "foo")
      assert :ok = Vx.validate(Vx.Intersect.t([Vx.String.t(), "foo"]), "foo")

      assert :ok =
               Vx.validate(
                 Vx.Intersect.t([
                   Vx.String.min_length(2),
                   Vx.String.max_length(4)
                 ]),
                 "foo"
               )
    end

    test "no match" do
      assert {:error, error} =
               Vx.validate(Vx.Intersect.t([Vx.Integer.t()]), "foo")

      assert Exception.message(error) == "must be an integer"

      assert {:error, _} =
               Vx.validate(
                 Vx.Intersect.t([Vx.String.t(), Vx.Number.t()]),
                 "foo"
               )

      assert {:error, _} =
               Vx.validate(Vx.Intersect.t([Vx.String.t(), "bar"]), "foo")

      assert {:error, error} =
               Vx.validate(
                 Vx.Intersect.t([
                   Vx.String.min_length(1),
                   Vx.String.max_length(2)
                 ]),
                 "foo"
               )

      assert Exception.message(error) ==
               "must be all of (string(min_length=1) & string(max_length=2))"
    end
  end
end
