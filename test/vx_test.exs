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
      assert {:error, _} =
               Vx.validate(schema, %{@valid_values | "type" => "guest"})

      assert {:error, _} =
               Vx.validate(schema, %{@valid_values | "hobbies" => []})

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
