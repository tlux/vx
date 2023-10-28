defmodule Vx.MapTest do
  use ExUnit.Case, async: true

  doctest Vx.Map

  @invalid ["", <<0xFFFF::16>>, nil, :foo, true, false, 123, []]

  test "t/0" do
    assert :ok = Vx.validate(Vx.Map.t(), %{})
    assert :ok = Vx.validate(Vx.Map.t(), %{"foo" => "bar"})

    Enum.each(@invalid, fn value ->
      assert {:error, _} = Vx.validate(Vx.Map.t(), value)
    end)
  end

  test "t/2" do
    schema = Vx.Map.t(Vx.String.t(), Vx.Number.t())

    assert :ok = Vx.validate(schema, %{"foo" => 123, "bar" => 234.5})
    assert {:error, _} = Vx.validate(schema, %{:foo => 123, "bar" => 234.5})
    assert {:error, _} = Vx.validate(schema, %{"foo" => "bar"})
    assert {:error, _} = Vx.validate(schema, %{"foo" => 123, "bar" => "bar"})

    schema = Vx.Map.t(Vx.Atom.t(), Vx.union([Vx.Number.t(), Vx.String.t()]))

    assert :ok = Vx.validate(schema, %{foo: 123, bar: "baz"})
    assert :ok = Vx.validate(schema, %{bar: "baz"})
    assert :ok = Vx.validate(schema, %{foo: 123, bar: 234})
  end

  describe "partial/1" do
    test "exact key and value" do
      assert :ok =
               Vx.validate(Vx.Map.partial(%{"foo" => "bar"}), %{"foo" => "bar"})

      assert {:error, _} =
               Vx.validate(Vx.Map.partial(%{"foo" => "bar"}), %{"foo" => "baz"})

      assert {:error, _} = Vx.validate(Vx.Map.partial(%{"foo" => "bar"}), %{})
    end

    test "schema value" do
      assert :ok =
               Vx.validate(Vx.Map.partial(%{"foo" => Vx.String.t()}), %{
                 "foo" => "bar"
               })

      assert {:error, _} =
               Vx.validate(Vx.Map.partial(%{"foo" => Vx.String.present()}), %{
                 "foo" => "  "
               })

      assert {:error, _} =
               Vx.validate(Vx.Map.partial(%{"foo" => Vx.String.present()}), %{})
    end

    test "optional key" do
      shape =
        Vx.Map.partial(%{
          Vx.optional("foo") => Vx.String.t(),
          "bar" => Vx.Number.t(),
          "baz" => Vx.optional(Vx.String.t())
        })

      assert :ok =
               Vx.validate(shape, %{
                 "foo" => "baz",
                 "bar" => 234,
                 "baz" => "foo"
               })

      assert :ok = Vx.validate(shape, %{"bar" => 234, "baz" => "foo"})
      assert {:error, _} = Vx.validate(shape, %{"foo" => "baz", "baz" => "foo"})

      assert {:error, _} =
               Vx.validate(shape, %{
                 "foo" => "baz",
                 "bar" => 123
               })

      assert :ok =
               Vx.validate(shape, %{
                 "foo" => "baz",
                 "bar" => 123,
                 "baz" => nil
               })
    end

    test "additional keys" do
      shape = Vx.Map.partial(%{"foo" => Vx.Number.t()})

      assert :ok = Vx.validate(shape, %{"foo" => 123, "bar" => "baz"})

      assert {:error, _} =
               Vx.validate(shape, %{"foo" => "hello", "bar" => "baz"})
    end
  end

  describe "shape/1" do
    test "exact key and value" do
      assert :ok =
               Vx.validate(Vx.Map.shape(%{"foo" => "bar"}), %{"foo" => "bar"})

      assert {:error, _} =
               Vx.validate(Vx.Map.shape(%{"foo" => "bar"}), %{"foo" => "baz"})

      assert {:error, _} = Vx.validate(Vx.Map.shape(%{"foo" => "bar"}), %{})
    end

    test "schema value" do
      assert :ok =
               Vx.validate(Vx.Map.shape(%{"foo" => Vx.String.t()}), %{
                 "foo" => "bar"
               })

      assert {:error, _} =
               Vx.validate(Vx.Map.shape(%{"foo" => Vx.String.present()}), %{})

      assert {:error, _} =
               Vx.validate(Vx.Map.shape(%{"foo" => Vx.String.present()}), %{
                 "foo" => "  "
               })
    end

    test "optional key" do
      shape =
        Vx.Map.shape(%{
          Vx.optional("foo") => Vx.String.t(),
          "bar" => Vx.Number.t(),
          "baz" => Vx.optional(Vx.String.t())
        })

      assert :ok =
               Vx.validate(shape, %{
                 "foo" => "baz",
                 "bar" => 234,
                 "baz" => "foo"
               })

      assert {:error, _} =
               Vx.validate(shape, %{
                 "foo" => "baz",
                 "bar" => 234,
                 "baz" => "foo",
                 "qix" => "hey"
               })

      assert :ok = Vx.validate(shape, %{"bar" => 234, "baz" => "foo"})
      assert {:error, _} = Vx.validate(shape, %{"foo" => "baz", "baz" => "foo"})

      assert {:error, _} =
               Vx.validate(shape, %{
                 "foo" => "baz",
                 "bar" => 123
               })

      assert :ok =
               Vx.validate(shape, %{
                 "foo" => "baz",
                 "bar" => 123,
                 "baz" => nil
               })
    end

    test "additional keys" do
      shape = Vx.Map.shape(%{"foo" => Vx.Number.t()})

      assert {:error, _} = Vx.validate(shape, %{"foo" => 123, "bar" => "baz"})
    end
  end
end
