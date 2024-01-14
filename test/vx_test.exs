defmodule VxTest do
  use ExUnit.Case

  @valid_values %{
    "name" => "foo",
    "age" => 18,
    "hobbies" => ["foo", "bar"],
    "type" => "admin",
    "addresses" => [%Address{street: "baz"}]
  }

  test "complex schema" do
    schema =
      Vx.Map.shape(%{
        "name" => Vx.String.t(),
        "age" => Vx.Number.t(),
        "hobbies" =>
          Vx.List.t(Vx.String.present())
          |> Vx.List.non_empty(),
        "type" => Vx.Any.of(["user", "admin"]),
        "addresses" => Vx.List.t(Vx.Struct.t(Address))
      })

    assert :ok = Vx.validate(schema, @valid_values)
    assert :ok = Vx.validate(schema, %{@valid_values | "type" => "user"})

    assert {:error, _} = Vx.validate(schema, %{@valid_values | "hobbies" => []})

    assert {:error, _} =
             Vx.validate(schema, %{
               @valid_values
               | "hobbies" => ["foo", "  "]
             })

    assert {:error, _} =
             Vx.validate(schema, %{
               @valid_values
               | "addresses" =>
                   @valid_values["addresses"] ++ [%Country{code: "DE"}]
             })
  end

  describe "eq/1" do
    test "match" do
      assert Vx.valid?(Vx.eq("foo"), "foo")
    end

    test "no match" do
      refute Vx.valid?(Vx.eq("foo"), "bar")
    end
  end

  describe "eq/2" do
    test "match" do
      assert Vx.valid?(Vx.eq(Vx.Any.t(), "foo"), "foo")
      assert Vx.valid?(Vx.eq(Vx.String.t(), "foo"), "foo")
    end

    test "no match" do
      refute Vx.valid?(Vx.eq(Vx.String.t(), "foo"), "bar")
      refute Vx.valid?(Vx.eq(Vx.Integer.t(), "foo"), "foo")
    end
  end

  describe "non/1" do
    test "match" do
      refute Vx.valid?(Vx.non("foo"), "foo")
    end

    test "no match" do
      assert Vx.valid?(Vx.non("foo"), "bar")
    end
  end

  describe "null/0" do
    test "match" do
      assert Vx.valid?(Vx.null(), nil)
    end

    test "no match" do
      refute Vx.valid?(Vx.null(), "foo")
      refute Vx.valid?(Vx.null(), 0)
      refute Vx.valid?(Vx.null(), false)
    end
  end

  describe "non_null/0" do
    test "match" do
      assert Vx.valid?(Vx.non_null(), "foo")
      assert Vx.valid?(Vx.non_null(), 0)
      assert Vx.valid?(Vx.non_null(), false)
    end

    test "no match" do
      refute Vx.valid?(Vx.non_null(), nil)
    end
  end

  describe "of/1" do
    test "match" do
      assert Vx.valid?(Vx.of(["foo", "bar"]), "foo")
    end

    test "no match" do
      refute Vx.valid?(Vx.of(["foo", "bar"]), "baz")
    end
  end

  describe "of/2" do
    test "match" do
      assert Vx.valid?(Vx.of(Vx.Any.t(), ["foo", "bar"]), "foo")
      assert Vx.valid?(Vx.of(Vx.String.t(), ["foo", "bar"]), "foo")
    end

    test "no match" do
      refute Vx.valid?(Vx.of(Vx.String.t(), ["foo", "bar"]), "baz")
      refute Vx.valid?(Vx.of(Vx.Integer.t(), ["foo", "bar"]), "foo")
    end
  end

  describe "optional/1" do
    @map_with_optional_key Vx.Map.shape(%{Vx.optional("foo") => Vx.Any.t()})

    test "match" do
      assert Vx.valid?(Vx.optional(Vx.String.t()), "foo")
      assert Vx.valid?(Vx.optional(Vx.String.t()), "bar")
      assert Vx.valid?(Vx.optional(Vx.String.t()), nil)
      assert Vx.valid?(@map_with_optional_key, %{"foo" => true})
      assert Vx.valid?(@map_with_optional_key, %{})
    end

    test "no match" do
      refute Vx.valid?(Vx.optional("foo"), "bar")
      refute Vx.valid?(Vx.optional(Vx.String.t()), 1)
      refute Vx.valid?(@map_with_optional_key, %{"bar" => true})
    end
  end

  describe "intersect/1" do
    test "match" do
      assert Vx.valid?(Vx.intersect([Vx.String.t(), "foo"]), "foo")
    end

    test "no match" do
      refute Vx.valid?(Vx.intersect([Vx.String.t(), Vx.Number.t()]), "foo")
      refute Vx.valid?(Vx.intersect([Vx.String.t(), "bar"]), "foo")
    end
  end

  describe "union/1" do
    test "match" do
      assert Vx.valid?(Vx.union([Vx.String.t(), Vx.Integer.t()]), "foo")
    end

    test "no match" do
      refute Vx.valid?(Vx.union(["bar", Vx.Integer.t()]), "foo")

      refute Vx.valid?(
               Vx.union([Vx.String.min_length(4), Vx.Integer.t()]),
               "foo"
             )
    end
  end
end
