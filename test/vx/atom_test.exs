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
        assert {:error, error} = Vx.validate(Vx.Atom.t(), value)
        assert Exception.message(error) == "must be an atom"
      end)
    end
  end
end
