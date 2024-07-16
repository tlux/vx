defmodule Vx.ConstrainedTest do
  use ExUnit.Case, async: true

  doctest Vx.Constrained

  describe "t/1" do
    test "wrap schema" do
      wrapped = Vx.String.t()

      assert %Vx.Constrained{schema: ^wrapped} = Vx.Constrained.t(wrapped)
    end

    test "do not wrap already-constrained" do
      schema = Vx.Constrained.t(Vx.String.t())

      assert Vx.Constrained.t(schema) == schema
    end
  end

  describe "Vx.validate/2" do
    test "without constraints" do
      assert Vx.String.t()
             |> Vx.Constrained.t()
             |> Vx.valid?("foo")

      refute Vx.String.t()
             |> Vx.Constrained.t()
             |> Vx.valid?(123)
    end

    test "with constraints" do
      valid_constraint = Vx.Validator.t(&String.valid?(&1))
      length_constraint = Vx.Validator.t(&(String.length(&1) >= 3))

      schema =
        Vx.Binary.t()
        |> Vx.Constrained.t()
        |> Vx.Constrained.put_constraint(valid_constraint)
        |> Vx.Constrained.put_constraint(length_constraint)

      assert Vx.valid?(schema, "foo")
      refute Vx.valid?(schema, "fo")
      refute Vx.valid?(schema, <<123, 456, 789, 0>>)
      refute Vx.valid?(schema, 123)
    end
  end
end
