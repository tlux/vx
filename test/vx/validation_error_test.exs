defmodule Vx.ValidationErrorTest do
  use ExUnit.Case

  alias Vx.ValidationError
  alias Vx.Validator

  describe "message/1" do
    test "without inner errors" do
      assert Exception.message(%ValidationError{
               validator: %Validator{type: Vx.Number},
               value: "foo"
             }) == ~s[Invalid Vx.Number (was "foo")]

      assert Exception.message(%ValidationError{
               validator: %Validator{
                 type: Vx.Number,
                 name: :integer
               },
               value: 123.4
             }) == ~s[Invalid Vx.Number: integer validation failed (was 123.4)]

      assert Exception.message(%ValidationError{
               validator: %Validator{
                 type: Vx.Number,
                 name: :lt,
                 details: %{value: 123},
                 message: "must be less than 123"
               },
               value: 124
             }) == ~s[Invalid Vx.Number: must be less than 123 (was 124)]
    end

    test "with inner errors" do
      assert Exception.message(%ValidationError{
               validator: %Validator{
                 type: Vx.Map,
                 name: :shape,
                 details: %{shape: %{foo: Vx.String}},
                 message: "does not have shape #{inspect(%{foo: Vx.String})}"
               },
               value: %{foo: 234.5},
               inner: %ValidationError{
                 validator: %Validator{
                   type: Vx.Number,
                   name: :lt,
                   details: %{value: 123},
                   message: "must be less than 123"
                 },
                 value: 124
               }
             }) ==
               ~s[Invalid Vx.Map: does not have shape %{foo: Vx.String} (was %{foo: 234.5})\n] <>
                 ~s[  Invalid Vx.Number: must be less than 123 (was 124)]
    end
  end
end
