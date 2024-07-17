defmodule Vx.ValidatorTest do
  use ExUnit.Case, async: true

  doctest Vx.Validator

  @value :foo

  describe "t/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.Validator.t(fn @value -> true end), @value)
      assert :ok = Vx.validate(Vx.Validator.t(fn @value -> :ok end), @value)
    end

    test "no match" do
      assert {:error, [error]} =
               Vx.validate(Vx.Validator.t(fn @value -> false end), @value)

      assert Exception.message(error) == "is invalid"

      assert {:error, [error]} =
               Vx.validate(Vx.Validator.t(fn @value -> :error end), @value)

      assert Exception.message(error) == "is invalid"

      assert {:error, [error]} =
               Vx.validate(
                 Vx.Validator.t(fn @value -> {:error, "does not match"} end),
                 @value
               )

      assert Exception.message(error) == "does not match"
    end
  end

  describe "t/2" do
    setup do
      {:ok, schema: Vx.Validator.t(Vx.String.t(), &String.contains?(&1, "foo"))}
    end

    test "match", %{schema: schema} do
      assert :ok = Vx.validate(schema, "foobar")
    end

    test "no match", %{schema: schema} do
      assert {:error, [error]} = Vx.validate(schema, 123)
      assert Exception.message(error) == "expected string"

      assert {:error, [error]} = Vx.validate(schema, "bar")
      assert Exception.message(error) == "is invalid"
    end
  end

  test "Vx.Printable.print/1" do
    assert Vx.Printable.print(Vx.Validator.t(fn _ -> true end)) ==
             "(custom validator)"
  end
end
