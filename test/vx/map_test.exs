defmodule Vx.MapTest do
  use ExUnit.Case, async: true

  @invalid ["", <<0xFFFF::16>>, nil, :foo, true, false, 123, []]

  test "t/0" do
    assert :ok = Vx.validate(Vx.Map.t(), %{})
    assert :ok = Vx.validate(Vx.Map.t(), %{"foo" => "bar"})

    Enum.each(@invalid, fn value ->
      assert {:error, _} = Vx.validate(Vx.Map.t(), value)
    end)
  end

  test "pairs/3"

  describe "shape/1" do
    test "exact key and value" do
      assert Vx.validate(Vx.Map.shape(%{"foo" => "bar"}), %{
               "foo" => "bar"
             })

      invalid_value = %{"foo" => "baz"}

      shape = %{"foo" => "bar"}

      assert {:error, _} = Vx.validate(Vx.Map.shape(shape), invalid_value)
    end

    test "schema value" do
      assert :ok =
               Vx.validate(Vx.Map.shape(%{"foo" => Vx.String.t()}), %{
                 "foo" => "bar"
               })

      invalid_value = %{"foo" => "  "}
      shape = %{"foo" => Vx.String.present()}

      assert {:error, _} = Vx.validate(Vx.Map.shape(shape), invalid_value)
    end

    test "optional key" do
      shape =
        Vx.Map.shape(%{
          Vx.optional("foo") => Vx.String.t(),
          "bar" => Vx.Number.t(),
          "baz" => Vx.optional(Vx.String.t())
        })

      assert :ok =
               Vx.validate(shape, %{
                 "foo" => "baz",
                 "bar" => 234,
                 "baz" => "foo"
               })

      assert :ok = Vx.validate(shape, %{"bar" => 234, "baz" => "foo"})
      assert {:error, _} = Vx.validate(shape, %{"foo" => "baz", "baz" => "foo"})

      assert {:error, _} =
               Vx.validate(shape, %{
                 "foo" => "baz",
                 "bar" => 123
               })

      assert :ok =
               Vx.validate(shape, %{
                 "foo" => "baz",
                 "bar" => 123,
                 "baz" => nil
               })
    end
  end
end
