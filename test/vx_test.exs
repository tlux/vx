defmodule VxTest do
  use ExUnit.Case, async: true

  doctest Vx

  @valid_values %{
    "name" => "foo",
    "age" => 18,
    "hobbies" => ["foo", "bar"],
    "type" => "admin",
    "addresses" => [%Address{street: "baz"}]
  }

  setup do
    {:ok,
     schema:
       Vx.Map.t(%{
         "name" => Vx.String.t(),
         "age" => Vx.Number.t(),
         "hobbies" =>
           Vx.List.t(Vx.String.present())
           |> Vx.List.non_empty(),
         "type" => Vx.Enum.t(["user", "admin"]),
         "addresses" => Vx.List.t(Vx.Struct.t(Address))
       })}
  end

  describe "validate/2" do
    test "valid", %{schema: schema} do
      assert :ok = Vx.validate(schema, @valid_values)
      assert :ok = Vx.validate(schema, %{@valid_values | "type" => "user"})
    end

    test "invalid", %{schema: schema} do
      assert {:error, [error]} =
               Vx.validate(schema, %{@valid_values | "type" => "guest"})

      assert Exception.message(error) ==
               ~s/expected enum("user", "admin") at ["type"]/

      assert {:error, [error]} =
               Vx.validate(schema, %{@valid_values | "hobbies" => []})

      assert Exception.message(error) ==
               ~s(must have at least 1 element at ["hobbies"])

      assert {:error, [error]} =
               Vx.validate(schema, %{
                 @valid_values
                 | "hobbies" => ["foo", "  "]
               })

      assert Exception.message(error) == ~s(must be present at ["hobbies", 1])

      assert {:error, [error]} =
               Vx.validate(schema, %{
                 @valid_values
                 | "addresses" =>
                     @valid_values["addresses"] ++ [%Country{code: "DE"}]
               })

      assert Exception.message(error) ==
               ~s(not a struct of type Address at ["addresses", 1])
    end
  end

  describe "validate!/2" do
    test "valid", %{schema: schema} do
      assert Vx.validate!(schema, @valid_values)
    end

    test "invalid", %{schema: schema} do
      assert_raise Vx.ValidationFailedError,
                   ~s/Validation failed: expected enum("user", "admin") at ["type"]/,
                   fn ->
                     Vx.validate!(schema, %{@valid_values | "type" => "guest"})
                   end
    end
  end
end
