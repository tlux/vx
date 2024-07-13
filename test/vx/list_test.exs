defmodule Vx.ListTest do
  use ExUnit.Case, async: true

  doctest Vx.List

  describe "t/0" do
    test "match" do
      assert :ok = Vx.validate(Vx.List.t(), [])
      assert :ok = Vx.validate(Vx.List.t(), ["foo", 123.4, true])
    end

    test "no match" do
      Enum.each([123, "foo", :foo, true, false], fn value ->
        assert {:error, [error]} = Vx.validate(Vx.List.t(), value)
        assert Exception.message(error) == "expected list"
      end)
    end
  end

  describe "t/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.List.t(Vx.String.t()), [])
      assert :ok = Vx.validate(Vx.List.t(Vx.String.t()), ["foo", "bar", "baz"])

      assert :ok =
               Vx.validate(
                 Vx.List.t(Vx.Union.t([Vx.String.t(), Vx.Integer.t()])),
                 ["foo", 123, "bar"]
               )
    end

    test "no match" do
      assert {:error, [error]} = Vx.validate(Vx.List.t(Vx.String.t()), "foo")
      assert Exception.message(error) == "expected list"

      assert {:error, [error_1, error_2]} =
               Vx.validate(Vx.List.t(Vx.String.t()), ["foo", 123.4, true])

      assert Exception.message(error_1) == "expected string at [1]"
      assert Exception.message(error_2) == "expected string at [2]"

      assert {:error, [error]} =
               Vx.validate(
                 Vx.List.t(Vx.Union.t([Vx.String.t(), Vx.Number.t()])),
                 ["foo", 123.4, true]
               )

      assert Exception.message(error) ==
               "expected string or number at [2]"
    end
  end

  describe "non_empty/0" do
    test "match" do
      assert :ok = Vx.validate(Vx.List.non_empty(), ["foo"])
    end

    test "no match" do
      assert {:error, [error]} = Vx.validate(Vx.List.non_empty(), "foo")
      assert Exception.message(error) == "expected list"

      assert {:error, [error]} = Vx.validate(Vx.List.non_empty(), [])
      assert Exception.message(error) == "must have at least 1 element"
    end
  end

  describe "length/1 with exact length" do
    test "match" do
      assert :ok = Vx.validate(Vx.List.length(is: 0), [])
      assert :ok = Vx.validate(Vx.List.length(is: 3), ["foo", 123.4, true])
    end

    test "no match" do
      schema = Vx.List.length(is: 3)

      assert {:error, [error]} = Vx.validate(schema, [])
      assert Exception.message(error) == "does not have a length of 3"

      assert {:error, _} = Vx.validate(schema, ["foo"])
      assert {:error, _} = Vx.validate(schema, ["foo", "bar"])
      assert {:error, _} = Vx.validate(schema, ["foo", "bar", 123.4, true])
    end
  end

  describe "shape/1" do
    setup do
      {:ok,
       schema: Vx.List.shape([Vx.String.t(), Vx.Integer.t(), Vx.Boolean.t()])}
    end

    test "match", %{schema: schema} do
      assert :ok = Vx.validate(schema, ["foo", 123, true])
    end

    test "no match", %{schema: schema} do
      assert Vx.error_messages_on(schema, []) == [
               "element at index 0 is missing",
               "element at index 1 is missing",
               "element at index 2 is missing"
             ]

      assert Vx.error_messages_on(schema, ["foo", 123]) == [
               "element at index 2 is missing"
             ]

      assert Vx.error_messages_on(schema, ["foo", 123, 234]) == [
               "expected boolean at [2]"
             ]

      assert Vx.error_messages_on(schema, ["foo", 123, true, "bar"]) == [
               "element at index 3 is abundant"
             ]
    end
  end
end
