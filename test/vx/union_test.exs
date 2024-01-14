defmodule Vx.UnionTest do
  use ExUnit.Case

  describe "t/1" do
    test "match" do
      assert Vx.valid?(Vx.union([Vx.String.t()]), "foo")
      assert Vx.valid?(Vx.union([Vx.String.t(), Vx.Integer.t()]), "foo")

      assert Vx.valid?(
               Vx.union([
                 Vx.String.min_length(6),
                 Vx.String.min_length(3),
                 Vx.Integer.t()
               ]),
               "foo"
             )
    end

    test "no match" do
      refute Vx.valid?(Vx.union([Vx.Integer.t()]), "foo")
      refute Vx.valid?(Vx.union(["bar", Vx.Integer.t()]), "foo")

      refute Vx.valid?(
               Vx.union([Vx.String.min_length(4), Vx.Integer.t()]),
               "foo"
             )

      refute Vx.valid?(
               Vx.union([Vx.String.min_length(4), Vx.Integer.t()]),
               "foo"
             )
    end
  end
end
