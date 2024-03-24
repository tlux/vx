defmodule VxTest do
  use ExUnit.Case, async: true

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
       Vx.Map.shape(%{
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
      assert {:error, error} =
               Vx.validate(schema, %{@valid_values | "type" => "guest"})

      assert Exception.message(error) ==
               "does not match shape\n" <>
                 ~s[- key "type": must be one of "user", "admin"]

      assert {:error, error} =
               Vx.validate(schema, %{@valid_values | "hobbies" => []})

      assert Exception.message(error) ==
               "does not match shape\n" <>
                 ~s[- key "hobbies": must not be empty]

      assert {:error, error} =
               Vx.validate(schema, %{
                 @valid_values
                 | "hobbies" => ["foo", "  "]
               })

      assert Exception.message(error) ==
               "does not match shape\n" <>
                 ~s[- key "hobbies": must be a list<string(present)>\n] <>
                 "- element 1: must be present"

      assert {:error, error} =
               Vx.validate(schema, %{
                 @valid_values
                 | "addresses" =>
                     @valid_values["addresses"] ++ [%Country{code: "DE"}]
               })

      assert Exception.message(error) ==
               "does not match shape\n" <>
                 ~s[- key "addresses": must be a list<struct<Address>>\n] <>
                 "- element 1: must be a struct of type Address"
    end
  end

  describe "validate!/2" do
    test "valid", %{schema: schema} do
      assert Vx.validate!(schema, @valid_values)
    end

    test "invalid", %{schema: schema} do
      assert_raise Vx.Error,
                   "does not match shape\n" <>
                     ~s[- key "type": must be one of "user", "admin"],
                   fn ->
                     Vx.validate!(schema, %{@valid_values | "type" => "guest"})
                   end
    end
  end
end
