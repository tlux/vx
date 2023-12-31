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
end
