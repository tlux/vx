defmodule Vx.ListTest do
  use ExUnit.Case, async: true

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
                 Vx.List.t([Vx.String.t(), Vx.Integer.t()]),
                 ["foo", 123, "bar"]
               )
    end

    test "no match" do
      assert {:error, error} = Vx.validate(Vx.List.t(Vx.String.t()), "foo")
      assert Exception.message(error) == "must be a typed list"

      assert {:error, _} =
               Vx.validate(Vx.List.t(Vx.String.t()), ["foo", 123.4, true])

      assert {:error, _} =
               Vx.validate(
                 Vx.List.t([Vx.String.t(), Vx.Integer.t()]),
                 ["foo", 123.4, true]
               )
    end
  end

  describe "non_empty/0" do
    test "match" do
      assert :ok = Vx.validate(Vx.List.non_empty(), ["foo"])
    end

    test "no match" do
      assert {:error, _} = Vx.validate(Vx.List.non_empty(), "foo")
      assert {:error, _} = Vx.validate(Vx.List.non_empty(), [])
    end
  end

  describe "non_empty/1" do
    setup do
      {:ok, schema: Vx.List.t(Vx.String.t()) |> Vx.List.non_empty()}
    end

    test "match", %{schema: schema} do
      assert :ok = Vx.validate(schema, ["foo", "bar"])
    end

    test "no match", %{schema: schema} do
      assert {:error, error} = Vx.validate(schema, [])
      assert Exception.message(error) == "must not be empty"

      assert {:error, _} = Vx.validate(schema, ["foo", 123])
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
      assert Exception.message(error) == "does not match expected shape"

      assert {:error, _} = Vx.validate(schema, ["foo", 123])
      assert {:error, _} = Vx.validate(schema, ["foo", 123, 234])
      assert {:error, _} = Vx.validate(schema, ["foo", 123, true, "bar"])
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
      assert {:error, _} = Vx.validate(schema, [])
      assert {:error, _} = Vx.validate(schema, ["foo", 123])
      assert {:error, _} = Vx.validate(schema, ["foo", 123, 234])
      assert {:error, _} = Vx.validate(schema, ["foo", 123, true, "bar"])
    end
  end

  describe "size/1" do
    setup do
      {:ok, schema: Vx.List.size(3)}
    end

    test "match", %{schema: schema} do
      assert :ok = Vx.validate(schema, ["foo", 123.4, true])
    end

    test "no match", %{schema: schema} do
      assert {:error, error} = Vx.validate(schema, [])
      assert Exception.message(error) == "does not match expected size of 3"

      assert {:error, _} = Vx.validate(schema, ["foo"])
      assert {:error, _} = Vx.validate(schema, ["foo", "bar"])
      assert {:error, _} = Vx.validate(schema, ["foo", "bar", 123.4, true])
    end
  end

  describe "size/2" do
    setup do
      {:ok, schema: Vx.List.t(Vx.String.t()) |> Vx.List.size(3)}
    end

    test "match", %{schema: schema} do
      assert :ok = Vx.validate(schema, ["foo", "bar", "baz"])
    end

    test "no match", %{schema: schema} do
      assert {:error, _} = Vx.validate(schema, [])
      assert {:error, _} = Vx.validate(schema, ["foo"])
      assert {:error, _} = Vx.validate(schema, ["foo", "bar"])
      assert {:error, _} = Vx.validate(schema, ["foo", "bar", "baz", "boom"])
      assert {:error, _} = Vx.validate(schema, ["foo", 123.4, true])
    end
  end
end
