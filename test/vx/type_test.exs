defmodule Vx.TypeTest do
  use ExUnit.Case, async: true

  test "new/2" do
    name = :foo
    fun = fn _ -> :ok end

    assert %Vx.Type{name: ^name, fun: ^fun} = Vx.Type.new(name, fun)
  end

  test "new/3" do
    name = :foo
    of = [:bar, :baz]
    fun = fn _ -> :ok end

    assert %Vx.Type{name: ^name, of: ^of, fun: ^fun} =
             Vx.Type.new(name, of, fun)
  end

  describe "constrain/3" do
    setup do
      {:ok, constrain_fun: fn _ -> :ok end}
    end

    test "plain type", %{constrain_fun: constrain_fun} do
      type = Vx.Type.new(:foo, fn _ -> :ok end)

      assert %Vx.Type{
               constraints: [%Vx.Constraint{name: :bar, fun: ^constrain_fun}]
             } = Vx.Type.constrain(type, :bar, constrain_fun)
    end

    test "wrapped type", %{constrain_fun: constrain_fun} do
      schema = Vx.Integer.t()

      assert %Vx.Integer{
               __type__: %Vx.Type{
                 constraints: [%Vx.Constraint{name: :bar, fun: ^constrain_fun}]
               }
             } = Vx.Type.constrain(schema, :bar, constrain_fun)
    end
  end

  test "constrain/4" do
    type = Vx.Type.new(:foo, fn _ -> :ok end)
    constrain_fun = fn _ -> :ok end
    value = "baz"

    assert %Vx.Type{
             constraints: [
               %Vx.Constraint{name: :bar, value: ^value, fun: ^constrain_fun}
             ]
           } = Vx.Type.constrain(type, :bar, value, constrain_fun)
  end

  describe "constraints/1" do
    setup do
      {:ok,
       constraints: [
         %Vx.Constraint{name: :foo, value: "bar", fun: fn _ -> :ok end},
         %Vx.Constraint{name: :bar, value: "foo", fun: fn _ -> :ok end}
       ]}
    end

    test "plain type", %{constraints: constraints} do
      type = %{Vx.Type.new(:foo, fn _ -> :ok end) | constraints: constraints}

      assert Vx.Type.constraints(type) == Enum.reverse(constraints)
    end

    test "wrapped type", %{constraints: constraints} do
      schema =
        Map.update!(Vx.Integer.t(), :__type__, fn type ->
          %{type | constraints: constraints}
        end)

      assert Vx.Type.constraints(schema) == Enum.reverse(constraints)
    end
  end

  describe "constraints/2" do
    setup do
      {:ok,
       constraints: [
         %Vx.Constraint{name: :foo, value: "foo", fun: fn _ -> :ok end},
         %Vx.Constraint{name: :bar, value: "foo", fun: fn _ -> :ok end},
         %Vx.Constraint{name: :foo, value: "bar", fun: fn _ -> :ok end}
       ]}
    end

    test "plain type", %{constraints: constraints} do
      type = %{
        Vx.Type.new(:foo, fn _ -> :ok end)
        | constraints: Enum.reverse(constraints)
      }

      assert [
               %Vx.Constraint{name: :foo, value: "foo"},
               %Vx.Constraint{name: :foo, value: "bar"}
             ] = Vx.Type.constraints(type, :foo)

      assert [] = Vx.Type.constraints(type, :baz)
    end

    test "wrapped type", %{constraints: constraints} do
      schema =
        Map.update!(Vx.Integer.t(), :__type__, fn type ->
          %{type | constraints: Enum.reverse(constraints)}
        end)

      assert [
               %Vx.Constraint{name: :foo, value: "foo"},
               %Vx.Constraint{name: :foo, value: "bar"}
             ] = Vx.Type.constraints(schema, :foo)
    end
  end

  describe "of/1" do
    test "plain type" do
      of = [Vx.String.t(), Vx.Integer.t()]
      type = Vx.Type.new(:foo, of, fn _ -> :ok end)

      assert Vx.Type.of(type) == of
    end

    test "wrapped type" do
      type = Vx.List.t(Vx.String.t())

      assert Vx.Type.of(type) == [Vx.String.t()]
    end
  end
end
