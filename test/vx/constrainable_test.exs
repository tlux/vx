defmodule Vx.ConstrainableTest do
  use ExUnit.Case, async: true

  describe "constrain_only/3" do
    test "not constrained" do
      assert Vx.Constrainable.constrain_only(
               Vx.Float.t(),
               [Vx.Float, Vx.Integer],
               Vx.Any.t()
             ) == Vx.Constrained.t(Vx.Float.t(), Vx.Any.t())
    end

    test "constrained" do
      constrained = Vx.Constrained.t(Vx.Float.t(), Vx.Any.t())

      assert Vx.Constrainable.constrain_only(
               constrained,
               [Vx.Float, Vx.Integer],
               Vx.String.t()
             ) == Vx.Constrained.t(constrained, Vx.String.t())
    end

    test "raise on incompatibility" do
      assert_raise Vx.IncompatibleConstraintError,
                   "unable to add constraint %Vx.Any{} to Vx.Integer (must be Vx.Float)",
                   fn ->
                     Vx.Constrainable.constrain_only(
                       Vx.Integer.t(),
                       Vx.Float,
                       Vx.Any.t()
                     )
                   end

      assert_raise Vx.IncompatibleConstraintError,
                   "unable to add constraint %Vx.String{} to Vx.Integer " <>
                     "(must be one of Vx.Float, Vx.Number)",
                   fn ->
                     Vx.Constrainable.constrain_only(
                       Vx.Integer.t(),
                       [Vx.Float, Vx.Number],
                       Vx.String.t()
                     )
                   end
    end
  end
end
