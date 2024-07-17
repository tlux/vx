defmodule Vx.AtomTest do
  use ExUnit.Case, async: true

  doctest Vx.Atom

  describe "t/0" do
    test "match" do
      Enum.each([nil, :foo, true, false], fn value ->
        assert :ok = Vx.validate(Vx.Atom.t(), value)
      end)
    end

    test "no match" do
      Enum.each([123, 123.4, "foo", %{}, []], fn value ->
        assert {:error, [error]} = Vx.validate(Vx.Atom.t(), value)
        assert Exception.message(error) == "expected atom"
      end)
    end
  end

  describe "custom/0" do
    test "match" do
      assert :ok = Vx.validate(Vx.Atom.custom(), :foo)
    end

    test "no match" do
      Enum.each([nil, 123, 123.4, "foo", %{}, []], fn value ->
        assert {:error, [error]} = Vx.validate(Vx.Atom.custom(), value)

        assert Exception.message(error) ==
                 "expected atom except boolean except nil"
      end)
    end
  end

  test "Vx.Printable.print/1" do
    assert Vx.Printable.print(Vx.Atom.t()) == "atom"
  end
end
