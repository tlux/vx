defmodule Vx.NumberTest do
  use ExUnit.Case, async: true

  doctest Vx.Number

  describe "t/0" do
    test "match" do
      assert :ok = Vx.validate!(Vx.Number.t(), 123)
      assert :ok = Vx.validate!(Vx.Number.t(), 123.0)
      assert :ok = Vx.validate!(Vx.Number.t(), 123.4)
    end

    test "no match" do
      Enum.each([nil, "foo", :foo, true, false], fn value ->
        assert {:error, [error]} = Vx.validate(Vx.Number.t(), value)
        assert Exception.message(error) == "expected number"
      end)
    end
  end

  describe "lt/1" do
    test "match" do
      assert :ok = Vx.validate!(Vx.Number.lt(100), 99)
    end

    test "no match" do
      assert {:error, [error]} = Vx.validate(Vx.Number.lt(100), 100)
      assert Exception.message(error) == "must be less than 100"

      assert {:error, _} = Vx.validate(Vx.Number.lt(100), 101)
    end
  end

  describe "lteq/1" do
    test "match" do
      assert :ok = Vx.validate!(Vx.Number.lteq(100), 100)
      assert :ok = Vx.validate!(Vx.Number.lteq(100), 99)
    end

    test "no match" do
      assert {:error, [error]} = Vx.validate(Vx.Number.lteq(100), 101)
      assert Exception.message(error) == "must be less than or equal to 100"
    end
  end

  describe "gt/1" do
    test "match" do
      assert :ok = Vx.validate!(Vx.Number.gt(100), 101)
    end

    test "no match" do
      assert {:error, [error]} = Vx.validate(Vx.Number.gt(100), 100)
      assert Exception.message(error) == "must be greater than 100"

      assert {:error, _} = Vx.validate(Vx.Number.gt(100), 99)
    end
  end

  describe "gteq/1" do
    test "match" do
      assert :ok = Vx.validate!(Vx.Number.gteq(100), 100)
      assert :ok = Vx.validate!(Vx.Number.gteq(100), 101)
    end

    test "no match" do
      assert {:error, [error]} = Vx.validate(Vx.Number.gteq(100), 99)
      assert Exception.message(error) == "must be greater than or equal to 100"
    end
  end

  describe "between/2" do
    test "match" do
      assert :ok = Vx.validate!(Vx.Number.between(1, 10), 1)
      assert :ok = Vx.validate!(Vx.Number.between(1, 10), 5)
      assert :ok = Vx.validate!(Vx.Number.between(1, 10), 10)
      assert :ok = Vx.validate!(Vx.Number.between(10, 1), 1)
      assert :ok = Vx.validate!(Vx.Number.between(10, 1), 5)
      assert :ok = Vx.validate!(Vx.Number.between(10, 1), 10)
      assert :ok = Vx.validate!(Vx.Number.between(3, 3), 3)
    end

    test "no match" do
      assert {:error, [error]} = Vx.validate(Vx.Number.between(1, 10), 0)
      assert Exception.message(error) == "must be between 1 and 10"

      assert {:error, _} = Vx.validate(Vx.Number.between(1, 10), 11)

      assert {:error, [error]} = Vx.validate(Vx.Number.between(12, 2), 0)
      assert Exception.message(error) == "must be between 2 and 12"

      assert {:error, _} = Vx.validate(Vx.Number.between(10, 1), 11)
    end
  end

  describe "non_fractional/0" do
    test "match" do
      assert :ok = Vx.validate!(Vx.Number.non_fractional(), 1)
      assert :ok = Vx.validate!(Vx.Number.non_fractional(), 1.0)
    end

    test "no match" do
      assert {:error, [error]} = Vx.validate(Vx.Number.non_fractional(), 1.1)
      assert Exception.message(error) == "must not be a fractional number"
    end
  end

  describe "non_fractional/1" do
    test "match" do
      assert :ok =
               Vx.Integer.t()
               |> Vx.Number.non_fractional()
               |> Vx.validate!(1)

      assert :ok =
               Vx.Float.t()
               |> Vx.Number.non_fractional()
               |> Vx.validate!(1.0)
    end

    test "no match" do
      assert {:error, [error]} =
               Vx.Float.t()
               |> Vx.Number.non_fractional()
               |> Vx.validate(1.1)

      assert Exception.message(error) == "must not be a fractional number"
    end
  end

  describe "positive/1" do
    test "match" do
      assert :ok = Vx.validate!(Vx.Number.positive(), 1)
      assert :ok = Vx.validate!(Vx.Number.positive(), 0.1)
    end

    test "no match" do
      assert {:error, [error]} = Vx.validate(Vx.Number.positive(), 0)
      assert Exception.message(error) == "must be greater than 0"

      assert {:error, _} = Vx.validate(Vx.Number.positive(), -1)
      assert {:error, _} = Vx.validate(Vx.Number.positive(), -0.1)
    end
  end

  describe "non_negative/1" do
    test "match" do
      assert :ok = Vx.validate!(Vx.Number.non_negative(), 0)
      assert :ok = Vx.validate!(Vx.Number.non_negative(), 0.1)
      assert :ok = Vx.validate!(Vx.Number.non_negative(), 1)
    end

    test "no match" do
      assert {:error, [error]} = Vx.validate(Vx.Number.non_negative(), -0.1)
      assert Exception.message(error) == "must be greater than or equal to 0"

      assert {:error, _} = Vx.validate(Vx.Number.non_negative(), -1)
      assert {:error, _} = Vx.validate(Vx.Number.non_negative(), -0.1)
    end
  end

  describe "negative/1" do
    test "match" do
      assert :ok = Vx.validate!(Vx.Number.negative(), -1)
      assert :ok = Vx.validate!(Vx.Number.negative(), -0.1)
    end

    test "no match" do
      assert {:error, [error]} = Vx.validate(Vx.Number.negative(), 0)
      assert Exception.message(error) == "must be less than 0"

      assert {:error, _} = Vx.validate(Vx.Number.negative(), 1)
      assert {:error, _} = Vx.validate(Vx.Number.negative(), 0.1)
    end
  end
end
