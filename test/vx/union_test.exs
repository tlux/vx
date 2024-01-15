defmodule Vx.UnionTest do
  use ExUnit.Case, async: true

  describe "t/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.union([Vx.String.t()]), "foo")
      assert :ok = Vx.validate(Vx.union([Vx.String.t(), Vx.Integer.t()]), "foo")

      assert :ok =
               Vx.validate(
                 Vx.union([
                   Vx.String.min_length(6),
                   Vx.String.min_length(3),
                   Vx.Integer.t()
                 ]),
                 "foo"
               )
    end

    test "no match" do
      assert {:error, _} = Vx.validate(Vx.union([Vx.Integer.t()]), "foo")
      assert {:error, _} = Vx.validate(Vx.union(["bar", Vx.Integer.t()]), "foo")

      assert {:error, _} =
               Vx.validate(
                 Vx.union([Vx.String.min_length(4), Vx.Integer.t()]),
                 "foo"
               )

      assert {:error, _} =
               Vx.validate(
                 Vx.union([Vx.String.min_length(4), Vx.Integer.t()]),
                 "foo"
               )
    end
  end
end
