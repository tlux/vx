defmodule Vx.ConstrainedTest do
  use ExUnit.Case, async: true

  doctest Vx.Constrained

  describe "t/1" do
    test "wrap schema" do
      schema = Vx.String.t()

      assert %Vx.Constrained{schema: ^schema} = Vx.Constrained.t(schema)
    end

    test "do not wrap already constrained schema" do
      wrapped = Vx.Constrained.t(Vx.String.t())

      assert Vx.Constrained.t(wrapped) == wrapped
    end
  end

  describe "t/2" do
    setup do
      schema = Vx.String.t()
      constraint = Vx.Validator.t(fn _ -> true end)
      {:ok, schema: schema, constraint: constraint}
    end

    test "allow single constraint as second arg", %{
      schema: schema,
      constraint: constraint
    } do
      assert Vx.Constrained.t(schema, [constraint]) ==
               Vx.Constrained.t(schema, constraint)
    end

    test "wrap schema with constraints", %{
      schema: schema,
      constraint: constraint
    } do
      constrained = Vx.Constrained.t(schema, [constraint])

      assert constrained.schema == schema
      assert Vx.Constrained.constraints(constrained) == [constraint]
    end

    test "do not wrap already constrained schema but add constraints", %{
      schema: schema,
      constraint: constraint
    } do
      constrained = Vx.Constrained.t(schema, [constraint])
      constraint_to_add = Vx.Validator.t(fn _ -> false end)
      updated_constrained = Vx.Constrained.t(constrained, [constraint_to_add])

      assert updated_constrained.schema == schema

      assert Vx.Constrained.constraints(updated_constrained) == [
               constraint,
               constraint_to_add
             ]
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

  describe "Vx.Printable.print/1" do
    test "with constraints" do
      schema =
        Vx.String.t()
        |> Vx.String.length(min: 1)
        |> Vx.String.length(max: 3)

      assert Vx.Printable.print(schema) == "string[length >= 1, length <= 3]"
    end

    test "without constraints" do
      schema = Vx.Constrained.t(Vx.String.t())

      assert Vx.Printable.print(schema) == "string"
    end
  end
end
