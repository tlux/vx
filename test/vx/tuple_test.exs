defmodule Vx.TupleTest do
  use ExUnit.Case, async: true

  describe "t/0" do
    test "match" do
      assert :ok = Vx.validate(Vx.Tuple.t(), {1})
      assert :ok = Vx.validate(Vx.Tuple.t(), {1, 2})
      assert :ok = Vx.validate(Vx.Tuple.t(), {1, 2, 3})
    end

    test "no match" do
      Enum.each([nil, "foo", :foo, true, false], fn value ->
        assert {:error, error} = Vx.validate(Vx.Tuple.t(), value)
        assert Exception.message(error) == "must be a tuple"
      end)
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
      assert {:error, error} = Vx.validate(Vx.Tuple.shape({1, 2, 3}), {1, 2})
      assert Exception.message(error) == "does not match expected shape"

      assert {:error, _} = Vx.validate(Vx.Tuple.shape({1, 2, 3}), {1, 2, 3, 4})

      assert {:error, _} =
               Vx.validate(Vx.Tuple.shape({1, Vx.String.t(), 3}), {1, 2, 3})
    end
  end

  describe "size/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.Tuple.size(1), {1})
      assert :ok = Vx.validate(Vx.Tuple.size(2), {1, 2})
      assert :ok = Vx.validate(Vx.Tuple.size(3), {1, 2, 3})
    end

    test "no match" do
      assert {:error, error} = Vx.validate(Vx.Tuple.size(2), {1})
      assert Exception.message(error) == "does not match expected size of 2"

      assert {:error, _} = Vx.validate(Vx.Tuple.size(2), {1, 2, 3})
    end
  end
end
