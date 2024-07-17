defmodule Vx.TupleTest do
  use ExUnit.Case, async: true

  doctest Vx.Tuple

  describe "t/0" do
    test "match" do
      assert :ok = Vx.validate(Vx.Tuple.t(), {1})
      assert :ok = Vx.validate(Vx.Tuple.t(), {1, 2})
      assert :ok = Vx.validate(Vx.Tuple.t(), {1, 2, 3})
    end

    test "no match" do
      Enum.each([nil, "foo", :foo, true, false], fn value ->
        assert {:error, [error]} = Vx.validate(Vx.Tuple.t(), value)
        assert Exception.message(error) == "expected tuple"
      end)
    end
  end

  describe "t/1" do
    test "alias for shape/1" do
      assert Vx.Tuple.t({1, 2, 3}) == Vx.Tuple.shape({1, 2, 3})
    end
  end

  describe "shape/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.Tuple.shape({1, 2, 3}), {1, 2, 3})
      assert :ok = Vx.validate(Vx.Tuple.shape({1, Vx.Number.t()}), {1, 2.3})

      assert :ok =
               Vx.validate(
                 Vx.Tuple.shape({Vx.String.t(), Vx.Number.t()}),
                 {"foo", 123.4}
               )
    end

    test "no match" do
      assert {:error, [error]} = Vx.validate(Vx.Tuple.shape({1, 2, 3}), {1, 2})
      assert Exception.message(error) == "element at index 2 is missing"

      assert {:error, _} = Vx.validate(Vx.Tuple.shape({1, 2, 3}), {1, 2, 3, 4})

      assert {:error, [error]} =
               Vx.validate(Vx.Tuple.shape({1, Vx.String.t(), 3}), {1, 2, 3})

      assert Exception.message(error) == "expected string at [1]"
    end
  end

  describe "size/1 with exact size" do
    test "match" do
      assert :ok = Vx.validate(Vx.Tuple.size(is: 1), {1})
      assert :ok = Vx.validate(Vx.Tuple.size(is: 2), {1, 2})
      assert :ok = Vx.validate(Vx.Tuple.size(is: 3), {1, 2, 3})
    end

    test "no match" do
      assert {:error, [error]} = Vx.validate(Vx.Tuple.size(is: 2), {1})
      assert Exception.message(error) == "does not have a size of 2"

      assert {:error, _} = Vx.validate(Vx.Tuple.size(is: 2), {1, 2, 3})
    end
  end

  describe "size/1 with min size" do
    test "match" do
      assert :ok = Vx.validate(Vx.Tuple.size(min: 0), {})
      assert :ok = Vx.validate(Vx.Tuple.size(min: 3), {"foo", 123.4, true})
    end

    test "no match" do
      assert {:error, [error]} = Vx.validate(Vx.Tuple.size(min: 2), {"foo"})
      assert Exception.message(error) == "does not have a minimal size of 2"
    end
  end

  describe "size/1 with max size" do
    test "match" do
      assert :ok = Vx.validate(Vx.Tuple.size(max: 0), {})
      assert :ok = Vx.validate(Vx.Tuple.size(max: 3), {"foo", 123.4, true})
    end

    test "no match" do
      assert {:error, [error]} =
               Vx.validate(Vx.Tuple.size(max: 2), {"foo", "bar", "baz"})

      assert Exception.message(error) == "exceeds the maximal size of 2"
    end
  end
end
