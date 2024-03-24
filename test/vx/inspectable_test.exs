defmodule Vx.InspectableTest do
  use ExUnit.Case

  alias Vx.Inspectable

  describe "inspect/1" do
    test "delegate to Kernel.inspect" do
      Enum.each(
        ["foo", 1.23, :foo, nil, true, false],
        fn value ->
          assert Inspectable.inspect(value) == inspect(value)
        end
      )

      assert Inspectable.inspect(Vx.Literal.t("foo")) == inspect("foo")
    end

    test "type names" do
      assert Inspectable.inspect(Vx.Any.t()) == "any"
      assert Inspectable.inspect(Vx.String.t()) == "string"
      assert Inspectable.inspect(Vx.Number.t()) == "number"
      assert Inspectable.inspect(Vx.Boolean.t()) == "boolean"
      assert Inspectable.inspect(Vx.List.t(Vx.String.t())) == "list<string>"

      assert Inspectable.inspect(Vx.Map.t(Vx.String.t(), Vx.Number.t())) ==
               "map<string, number>"

      assert Inspectable.inspect(Vx.Nullable.t(Vx.String.t())) ==
               "(string | nil)"

      assert Inspectable.inspect(Vx.Optional.t(Vx.String.t())) == "string?"
      assert Inspectable.inspect(Vx.Not.t(Vx.String.t())) == "!string"

      assert Inspectable.inspect(Vx.Enum.t([:foo, :bar])) == "enum[:foo, :bar]"

      assert Inspectable.inspect(Vx.Validator.t(fn _ -> :ok end)) ==
               "(custom validator)"
    end

    test "list" do
      assert Inspectable.inspect([1, 2, 3]) == "[1, 2, 3]"

      assert Inspectable.inspect([Vx.String.t(), Vx.Number.t()]) ==
               "[string, number]"
    end

    test "map" do
      assert Inspectable.inspect(%{a: 1, b: 2}) == "%{:a => 1, :b => 2}"

      assert Inspectable.inspect(%{Vx.String.t() => Vx.Number.t()}) ==
               "%{string => number}"
    end

    test "tuple" do
      assert Inspectable.inspect({1, 2, 3}) == "{1, 2, 3}"

      assert Inspectable.inspect({Vx.String.t(), Vx.Number.t()}) ==
               "{string, number}"
    end
  end
end
