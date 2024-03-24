defmodule Vx.ValidatorTest do
  use ExUnit.Case, async: true

  @value :foo

  describe "t/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.Validator.t(fn @value -> true end), @value)
      assert :ok = Vx.validate(Vx.Validator.t(fn @value -> :ok end), @value)
    end

    test "no match" do
      assert {:error, error} =
               Vx.validate(Vx.Validator.t(fn @value -> false end), @value)

      assert Exception.message(error) == "is invalid"

      assert {:error, error} =
               Vx.validate(Vx.Validator.t(fn @value -> :error end), @value)

      assert Exception.message(error) == "is invalid"

      assert {:error, error} =
               Vx.validate(
                 Vx.Validator.t(fn @value -> {:error, "does not match"} end),
                 @value
               )

      assert Exception.message(error) == "does not match"
    end
  end
end
