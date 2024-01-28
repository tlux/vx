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

    assert {:error, _} =
             Vx.validate(schema, %{@valid_values | "type" => "guest"})

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

  describe "optional/1" do
    setup do
      {:ok,
       map_with_optional_key: Vx.Map.shape(%{Vx.optional("foo") => Vx.Any.t()})}
    end

    test "match", %{map_with_optional_key: map_with_optional_key} do
      assert Vx.valid?(Vx.optional(Vx.String.t()), "foo")
      assert Vx.valid?(Vx.optional(Vx.String.t()), "bar")
      assert Vx.valid?(Vx.optional(Vx.String.t()), nil)
      assert Vx.valid?(map_with_optional_key, %{"foo" => true})
      assert Vx.valid?(map_with_optional_key, %{})
    end

    test "no match", %{map_with_optional_key: map_with_optional_key} do
      refute Vx.valid?(Vx.optional("foo"), "bar")
      refute Vx.valid?(Vx.optional(Vx.String.t()), 1)
      refute Vx.valid?(map_with_optional_key, %{"bar" => true})
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
      refute Vx.valid?(Vx.union([Vx.Literal.t("bar"), Vx.Integer.t()]), "foo")

      refute Vx.valid?(
               Vx.union([Vx.String.min_length(4), Vx.Integer.t()]),
               "foo"
             )
    end
  end
end
