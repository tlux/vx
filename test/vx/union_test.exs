defmodule Vx.UnionTest do
  use ExUnit.Case, async: true

  describe "t/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.Union.t([Vx.String.t()]), "foo")

      assert :ok =
               Vx.validate(Vx.Union.t([Vx.String.t(), Vx.Integer.t()]), "foo")

      assert :ok =
               Vx.validate(
                 Vx.Union.t([
                   Vx.String.min_length(6),
                   Vx.String.min_length(3),
                   Vx.Integer.t()
                 ]),
                 "foo"
               )
    end

    test "no match" do
      assert {:error, error} = Vx.validate(Vx.Union.t([Vx.Integer.t()]), "foo")

      assert Exception.message(error) ==
               ~s[must be an integer]

      assert {:error, _} =
               Vx.validate(Vx.Union.t(["bar", Vx.Integer.t()]), "foo")

      assert {:error, _} =
               Vx.validate(
                 Vx.Union.t([Vx.String.min_length(4), Vx.Integer.t()]),
                 "foo"
               )

      assert {:error, error} =
               Vx.validate(
                 Vx.Union.t([
                   Vx.String.t()
                   |> Vx.String.min_length(4)
                   |> Vx.String.max_length(8),
                   Vx.Integer.t()
                 ]),
                 "foo"
               )

      assert Exception.message(error) ==
               "must be any of (string(min_length=4, max_length=8) | integer)"
    end
  end
end
