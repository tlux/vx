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
        assert {:error, error} = Vx.validate(Vx.List.t(), value)
        assert Exception.message(error) == "must be a list"
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
      assert {:error, error} = Vx.validate(Vx.List.t(Vx.String.t()), "foo")
      assert Exception.message(error) == "must be a list"

      assert {:error, error} =
               Vx.validate(Vx.List.t(Vx.String.t()), ["foo", 123.4, true])

      assert Exception.message(error) ==
               "must be a list<string>\n" <>
                 "- element 1: must be a string\n" <>
                 "- element 2: must be a string"

      assert {:error, error} =
               Vx.validate(
                 Vx.List.t(Vx.Union.t([Vx.String.t(), Vx.Number.t()])),
                 ["foo", 123.4, true]
               )

      assert Exception.message(error) ==
               "must be a list<(string | number)>\n" <>
                 "- element 2: must be any of (string | number)"
    end
  end

  describe "non_empty/0" do
    test "match" do
      assert :ok = Vx.validate(Vx.List.non_empty(), ["foo"])
    end

    test "no match" do
      assert {:error, error} = Vx.validate(Vx.List.non_empty(), "foo")
      assert Exception.message(error) == "must be a list"

      assert {:error, error} = Vx.validate(Vx.List.non_empty(), [])
      assert Exception.message(error) == "must not be empty"
    end
  end

  describe "size/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.List.size(0), [])
      assert :ok = Vx.validate(Vx.List.size(3), ["foo", 123.4, true])
    end

    test "no match" do
      schema = Vx.List.size(3)

      assert {:error, error} = Vx.validate(schema, [])
      assert Exception.message(error) == "must have size of 3"

      assert {:error, _} = Vx.validate(schema, ["foo"])
      assert {:error, _} = Vx.validate(schema, ["foo", "bar"])
      assert {:error, _} = Vx.validate(schema, ["foo", "bar", 123.4, true])
    end

    test "invalid size" do
      assert_raise FunctionClauseError, fn ->
        Vx.List.size(-1)
      end

      assert_raise FunctionClauseError, fn ->
        Vx.List.size(1.1)
      end
    end
  end

  describe "min_size/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.List.min_size(0), [])
      assert :ok = Vx.validate(Vx.List.min_size(2), ["foo", "bar", "baz"])
      assert :ok = Vx.validate(Vx.List.min_size(3), ["foo", "bar", "baz"])
    end

    test "no match" do
      assert {:error, error} = Vx.validate(Vx.List.min_size(3), ["foo"])
      assert Exception.message(error) == "must have at least 3 elements"
    end

    test "invalid size" do
      assert_raise FunctionClauseError, fn ->
        Vx.List.min_size(-1)
      end

      assert_raise FunctionClauseError, fn ->
        Vx.List.min_size(1.1)
      end
    end
  end

  describe "max_size/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.List.max_size(0), [])
      assert :ok = Vx.validate(Vx.List.max_size(3), ["foo", "bar", "baz"])
      assert :ok = Vx.validate(Vx.List.max_size(4), ["foo", "bar", "baz"])
    end

    test "no match" do
      assert {:error, error} =
               Vx.validate(Vx.List.max_size(2), ["foo", "bar", "baz"])

      assert Exception.message(error) == "must have at most 2 elements"
    end

    test "invalid size" do
      assert_raise FunctionClauseError, fn ->
        Vx.List.max_size(-1)
      end

      assert_raise FunctionClauseError, fn ->
        Vx.List.max_size(1.1)
      end
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
      assert {:error, error} = Vx.validate(schema, [])

      assert Exception.message(error) ==
               "must match [string, integer, boolean]\n" <>
                 "- element 0 is missing\n" <>
                 "- element 1 is missing\n" <>
                 "- element 2 is missing"

      assert {:error, _} = Vx.validate(schema, ["foo", 123])
      assert {:error, _} = Vx.validate(schema, ["foo", 123, 234])

      assert {:error, error} = Vx.validate(schema, ["foo", 123, true, "bar"])

      assert Exception.message(error) ==
               "must match [string, integer, boolean]\n" <>
                 "- element 3 is abundant"
    end
  end

  describe "shape/2" do
    setup do
      {:ok,
       schema:
         Vx.List.t(Vx.Any.t())
         |> Vx.List.shape([
           Vx.String.t(),
           Vx.Integer.t(),
           Vx.Boolean.t()
         ])}
    end

    test "match", %{schema: schema} do
      assert :ok = Vx.validate(schema, ["foo", 123, true])
    end

    test "no match", %{schema: schema} do
      assert {:error, error} = Vx.validate(schema, [])

      assert Exception.message(error) ==
               "must match [string, integer, boolean]\n" <>
                 "- element 0 is missing\n" <>
                 "- element 1 is missing\n" <>
                 "- element 2 is missing"

      assert {:error, error} = Vx.validate(schema, ["foo", 123])

      assert Exception.message(error) ==
               "must match [string, integer, boolean]\n" <>
                 "- element 2 is missing"

      assert {:error, error} = Vx.validate(schema, ["foo", 123, 234])

      assert Exception.message(error) ==
               "must match [string, integer, boolean]\n" <>
                 "- element 2: must be a boolean"

      assert {:error, _} = Vx.validate(schema, ["foo", 123, true, "bar"])
    end
  end
end
