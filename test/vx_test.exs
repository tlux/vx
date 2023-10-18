defmodule VxTest do
  use ExUnit.Case

  alias Vx.Schema

  @valid_values %{
    "name" => "foo",
    "age" => 18,
    "hobbies" => ["foo", "bar"],
    "type" => "admin"
  }

  test "complex schema" do
    schema =
      Vx.Map.shape(%{
        "name" => Vx.String.t(),
        "age" => Vx.Number.t(),
        "hobbies" =>
          Vx.List.of(Vx.String.present())
          |> Vx.List.non_empty(),
        "type" => Vx.Any.of(["user", "admin"])
      })

    assert :ok = Vx.Schema.eval(schema, @valid_values)
    assert :ok = Vx.Schema.eval(schema, %{@valid_values | "type" => "user"})

    assert {:error, _} =
             Vx.Schema.eval(schema, %{@valid_values | "hobbies" => []})

    assert {:error, _} =
             Vx.Schema.eval(schema, %{
               @valid_values
               | "hobbies" => ["foo", "  "]
             })
  end
end
