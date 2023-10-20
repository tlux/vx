defmodule VxTest do
  use ExUnit.Case

  alias Vx.Schema

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
          Vx.List.of(Vx.String.present())
          |> Vx.List.non_empty(),
        "type" => Vx.Any.of(["user", "admin"]),
        "addresses" => Vx.List.of(Vx.Struct.t(Address))
      })

    assert :ok = Schema.eval(schema, @valid_values)
    assert :ok = Schema.eval(schema, %{@valid_values | "type" => "user"})

    assert {:error, _} = Schema.eval(schema, %{@valid_values | "hobbies" => []})

    assert {:error, _} =
             Schema.eval(schema, %{
               @valid_values
               | "hobbies" => ["foo", "  "]
             })
  end
end
