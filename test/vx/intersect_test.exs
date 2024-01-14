defmodule Vx.IntersectTest do
  use ExUnit.Case, async: true

  describe "t/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.intersect([Vx.String.t()]), "foo")

      assert :ok = Vx.validate(Vx.intersect([Vx.String.t(), "foo"]), "foo")

      assert :ok =
               Vx.validate(
                 Vx.intersect([Vx.String.min_length(2), Vx.String.max_length(4)]),
                 "foo"
               )
    end

    test "no match" do
      assert {:error, _} = Vx.validate(Vx.intersect([Vx.Integer.t()]), "foo")

      assert {:error, _} =
               Vx.validate(Vx.intersect([Vx.String.t(), Vx.Number.t()]), "foo")

      assert {:error, _} =
               Vx.validate(Vx.intersect([Vx.String.t(), "bar"]), "foo")

      assert {:error, _} =
               Vx.validate(
                 Vx.intersect([Vx.String.min_length(1), Vx.String.max_length(2)]),
                 "foo"
               )
    end
  end
end
