defmodule Vx.AnyTest do
  use ExUnit.Case, async: true

  describe "t/0" do
    test "match" do
      Enum.each(["foo", :foo, true, false, 123, 123.4], fn value ->
        assert :ok = Vx.validate(Vx.Any.t(), value)
      end)
    end
  end

  describe "eq/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.Any.eq("foo"), "foo")
    end

    test "no match" do
      assert {:error, error} = Vx.validate(Vx.Any.eq("foo"), "bar")
      assert Exception.message(error) =~ ~s[must be equal to "foo"]
    end
  end

  describe "eq/2" do
    test "match" do
      assert :ok = Vx.validate(Vx.Any.eq(Vx.Any.t(), "foo"), "foo")
      assert :ok = Vx.validate(Vx.Any.eq(Vx.String.t(), "foo"), "foo")
    end

    test "no match" do
      assert {:error, error} =
               Vx.validate(Vx.Any.eq(Vx.String.t(), "foo"), "bar")

      assert Exception.message(error) == ~s[must be equal to "foo"]

      assert {:error, error} =
               Vx.validate(Vx.Any.eq(Vx.Integer.t(), "foo"), 123)

      assert Exception.message(error) == ~s[must be equal to "foo"]
    end
  end

  describe "of/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.Any.of(["foo", "bar"]), "foo")
    end

    test "no match" do
      assert {:error, error} =
               Vx.validate(Vx.Any.of(["foo", "bar", "boom"]), "baz")

      assert Exception.message(error) =~
               ~s[must be one of "foo", "bar", "boom"]
    end
  end

  describe "of/2" do
    test "match" do
      assert :ok = Vx.validate(Vx.Any.of(Vx.Any.t(), ["foo", "bar"]), "foo")
      assert :ok = Vx.validate(Vx.Any.of(Vx.String.t(), ["foo", "bar"]), "foo")
    end

    test "no match" do
      assert {:error, error} =
               Vx.validate(Vx.Any.of(Vx.String.t(), ["foo", "bar"]), "baz")

      assert Exception.message(error) == ~s[must be one of "foo", "bar"]

      assert {:error, error} =
               Vx.validate(Vx.Any.of(Vx.Integer.t(), ["foo", "bar"]), "foo")

      assert Exception.message(error) == "must be an integer"
    end
  end

  describe "match/1" do
    require Vx.Any

    test "match" do
      assert :ok = Vx.validate(Vx.Any.match("foo"), "foo")
      assert :ok = Vx.validate(Vx.Any.match({:ok, _}), {:ok, "foo"})
    end

    test "no match" do
      assert {:error, error} = Vx.validate(Vx.Any.match("foo"), "bar")

      assert Exception.message(error) == ~s[must match "foo"]

      assert {:error, error} =
               Vx.validate(Vx.Any.match({:error, _}), {:ok, "foo"})

      assert Exception.message(error) == ~s[must match {:error, _}]
    end
  end
end
