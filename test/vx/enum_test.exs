defmodule Vx.EnumTest do
  use ExUnit.Case, async: true

  doctest Vx.Enum

  describe "t/1" do
    setup do
      {:ok, schema: Vx.Enum.t([:foo, "bar"])}
    end

    test "match", %{schema: schema} do
      assert :ok = Vx.validate!(schema, :foo)
      assert :ok = Vx.validate!(schema, "bar")
    end

    test "no match", %{schema: schema} do
      assert {:error, error} = Vx.validate(schema, :baz)
      assert Exception.message(error) == ~s[must be one of :foo, "bar"]
    end
  end
end
