defmodule Vx.UtilTest do
  use ExUnit.Case, async: true

  alias Vx.Util

  test "inspect_enum/1" do
    assert Util.inspect_enum(["foo", :bar, 123]) == ~s["foo", :bar, 123]
  end

  test "inspect_enum/2" do
    assert Util.inspect_enum(
             [
               Vx.String.t(),
               Vx.Literal.t("foo"),
               Vx.List.t(Vx.Number.t()),
               :bar
             ],
             &Vx.Inspectable.inspect/1
           ) == ~s[string, "foo", list<number>, :bar]
  end
end
