defmodule Vx.OptionalTest do
  use ExUnit.Case, async: true

  describe "t/1" do
    setup do
      {:ok,
       map_with_optional_key:
         Vx.Map.shape(%{Vx.Optional.t("foo") => Vx.Any.t()})}
    end

    test "match", %{map_with_optional_key: map_with_optional_key} do
      assert :ok = Vx.validate(Vx.Optional.t(Vx.String.t()), "foo")
      assert :ok = Vx.validate(Vx.Optional.t(Vx.String.t()), "bar")
      assert :ok = Vx.validate(Vx.Optional.t(Vx.String.t()), nil)
      assert :ok = Vx.validate(map_with_optional_key, %{"foo" => true})
      assert :ok = Vx.validate(map_with_optional_key, %{})
    end

    test "no match", %{map_with_optional_key: map_with_optional_key} do
      assert {:error, error} = Vx.validate(Vx.Optional.t("foo"), "bar")
      assert Exception.message(error) == ~s[must be "foo"?]

      assert {:error, _} = Vx.validate(Vx.Optional.t(Vx.String.t()), 1)
      assert {:error, _} = Vx.validate(map_with_optional_key, %{"bar" => true})
    end
  end
end
