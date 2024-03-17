defmodule Vx.NumberTest do
  use ExUnit.Case, async: true

  describe "t/0" do
    test "match" do
      assert :ok = Vx.validate(Vx.Number.t(), 123)
      assert :ok = Vx.validate(Vx.Number.t(), 123.0)
      assert :ok = Vx.validate(Vx.Number.t(), 123.4)
    end

    test "no match" do
      Enum.each([nil, "foo", :foo, true, false], fn value ->
        assert {:error, error} = Vx.validate(Vx.Number.t(), value)
        assert Exception.message(error) == "must be a number"
      end)
    end
  end

  describe "lt/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.Number.lt(100), 99)
    end

    test "no match" do
      assert {:error, error} = Vx.validate(Vx.Number.lt(100), 100)
      assert Exception.message(error) == "must be less than 100"

      assert {:error, _} = Vx.validate(Vx.Number.lt(100), 101)
    end
  end

  describe "lteq/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.Number.lteq(100), 100)
      assert :ok = Vx.validate(Vx.Number.lteq(100), 99)
    end

    test "no match" do
      assert {:error, error} = Vx.validate(Vx.Number.lteq(100), 101)
      assert Exception.message(error) == "must be less than or equal to 100"
    end
  end

  describe "gt/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.Number.gt(100), 101)
    end

    test "no match" do
      assert {:error, error} = Vx.validate(Vx.Number.gt(100), 100)
      assert Exception.message(error) == "must be greater than 100"

      assert {:error, _} = Vx.validate(Vx.Number.gt(100), 99)
    end
  end

  describe "gteq/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.Number.gteq(100), 100)
      assert :ok = Vx.validate(Vx.Number.gteq(100), 101)
    end

    test "no match" do
      assert {:error, error} = Vx.validate(Vx.Number.gteq(100), 99)
      assert Exception.message(error) == "must be greater than or equal to 100"
    end
  end

  describe "range/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.Number.range(1..10), 1)
      assert :ok = Vx.validate(Vx.Number.range(1..10), 5)
      assert :ok = Vx.validate(Vx.Number.range(1..10), 10)
      assert :ok = Vx.validate(Vx.Number.range(1..10//2), 3)
    end

    test "no match" do
      assert {:error, error} = Vx.validate(Vx.Number.range(1..10), 11)
      assert Exception.message(error) == "must be in range 1..10"

      assert {:error, _} = Vx.validate(Vx.Number.range(1..10), 0)
      assert {:error, _} = Vx.validate(Vx.Number.range(1..10//2), 4)
    end
  end

  describe "between/2" do
    test "match" do
      assert :ok = Vx.validate(Vx.Number.between(1, 10), 1)
      assert :ok = Vx.validate(Vx.Number.between(1, 10), 5)
      assert :ok = Vx.validate(Vx.Number.between(1, 10), 10)
      assert :ok = Vx.validate(Vx.Number.between(10, 1), 1)
      assert :ok = Vx.validate(Vx.Number.between(10, 1), 5)
      assert :ok = Vx.validate(Vx.Number.between(10, 1), 10)
      assert :ok = Vx.validate(Vx.Number.between(3, 3), 3)
    end

    test "no match" do
      assert {:error, error} = Vx.validate(Vx.Number.between(1, 10), 0)
      assert Exception.message(error) == "must be between 1 and 10"

      assert {:error, _} = Vx.validate(Vx.Number.between(1, 10), 11)

      assert {:error, error} = Vx.validate(Vx.Number.between(10, 1), 0)
      assert Exception.message(error) == "must be between 1 and 10"

      assert {:error, _} = Vx.validate(Vx.Number.between(10, 1), 11)
    end
  end

  describe "integer/0" do
    test "match" do
      assert :ok = Vx.validate(Vx.Number.integer(), 1)
      assert :ok = Vx.validate(Vx.Number.integer(), 1.0)
    end

    test "no match" do
      assert {:error, error} = Vx.validate(Vx.Number.integer(), 1.1)
      assert Exception.message(error) == "must be an integer"
    end
  end
end
