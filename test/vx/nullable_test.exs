defmodule Vx.NullableTest do
  use ExUnit.Case, async: true

  doctest Vx.Nullable

  describe "t/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.Nullable.t(Vx.String.t()), "foo")
      assert :ok = Vx.validate(Vx.Nullable.t(Vx.String.t()), nil)
      assert :ok = Vx.validate(Vx.Nullable.t("foo"), "foo")
      assert :ok = Vx.validate(Vx.Nullable.t("foo"), nil)
    end

    test "no match" do
      assert {:error, error} = Vx.validate(Vx.Nullable.t(Vx.String.t()), 123)
      assert Exception.message(error) == ~s[must be (string | nil)]

      assert {:error, error} = Vx.validate(Vx.Nullable.t("foo"), 123)
      assert Exception.message(error) == ~s[must be ("foo" | nil)]
    end
  end
end
