defmodule Vx.SchemaTest do
  use ExUnit.Case

  alias Vx.Schema

  test "any_of/1" do
    schemata = [Vx.String.t(), Vx.Integer.t()]

    assert Schema.eval(Vx.any_of([]), "Foo") == :ok
    assert Schema.eval(Vx.any_of(schemata), "Foo") == :ok
    assert Schema.eval(Vx.any_of(schemata), 123) == :ok

    assert Schema.eval(Vx.any_of(schemata), true) ==
             {:error, Vx.TypeError.new({:any_of, schemata}, nil, true)}
  end
end
