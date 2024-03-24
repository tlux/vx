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
      type = Vx.Integer.t()

      assert %Vx.Integer{
               __type__: %Vx.Type{
                 constraints: [%Vx.Constraint{name: :bar, fun: ^constrain_fun}]
               }
             } = Vx.Type.constrain(type, :bar, constrain_fun)
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
      type =
        Map.update!(Vx.Integer.t(), :__type__, fn type ->
          %{type | constraints: constraints}
        end)

      assert Vx.Type.constraints(type) == Enum.reverse(constraints)
    end
  end
end
