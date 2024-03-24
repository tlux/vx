defmodule Vx.MatchTest do
  use ExUnit.Case, async: true

  require Vx.Match

  describe "t/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.Match.t("foo"), "foo")
      assert :ok = Vx.validate(Vx.Match.t({:ok, _}), {:ok, "foo"})
    end

    test "no match" do
      assert {:error, error} = Vx.validate(Vx.Match.t("foo"), "bar")
      assert Exception.message(error) == ~s[must match "foo"]

      assert {:error, error} =
               Vx.validate(Vx.Match.t({:error, _}), {:ok, "foo"})

      assert Exception.message(error) == ~s[must match {:error, _}]
    end
  end
end
