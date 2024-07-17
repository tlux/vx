defmodule VxTest do
  use ExUnit.Case, async: true

  import Vx.Force

  @valid_value "foo"
  @invalid_value 123

  setup do
    {:ok, schema: Vx.String.t()}
  end

  describe "validate/2" do
    test "valid", %{schema: schema} do
      assert Vx.validate(schema, @valid_value) == :ok
    end

    test "invalid", %{schema: schema} do
      assert Vx.validate(schema, @invalid_value) ==
               {:error,
                [%Vx.Error{schema: schema, actual_value: @invalid_value}]}
    end
  end

  describe "validate!/2" do
    test "valid", %{schema: schema} do
      assert Vx.validate!(schema, @valid_value) == :ok
    end

    test "invalid", %{schema: schema} do
      assert_raise Vx.ValidationFailedError,
                   "Validation failed: expected string",
                   fn ->
                     Vx.validate!(schema, @invalid_value)
                   end
    end
  end

  describe "valid?/2" do
    test "valid", %{schema: schema} do
      assert Vx.valid?(schema, @valid_value) == true
    end

    test "invalid", %{schema: schema} do
      assert Vx.valid?(schema, @invalid_value) == false
    end
  end

  describe "errors_on/2" do
    test "valid" do
      Enum.each([true, :ok], fn result ->
        assert Vx.errors_on(force(result), @valid_value) == []
      end)
    end

    test "false" do
      assert [%Vx.Error{message: nil, actual_value: @invalid_value}] =
               Vx.errors_on(force(false), @invalid_value)
    end

    test "error" do
      assert [%Vx.Error{message: nil, actual_value: @invalid_value}] =
               Vx.errors_on(force(:error), @invalid_value)
    end

    test "error tuple with single message" do
      assert [
               %Vx.Error{
                 message: "Something went wrong",
                 actual_value: @invalid_value
               }
             ] =
               Vx.errors_on(
                 force({:error, "Something went wrong"}),
                 @invalid_value
               )
    end

    test "error tuple with single message and path" do
      assert [
               %Vx.Error{
                 message: "Something went wrong",
                 actual_value: @invalid_value,
                 path: ["foo", "bar"]
               }
             ] =
               Vx.errors_on(
                 force({:error, {["foo", "bar"], "Something went wrong"}}),
                 @invalid_value
               )
    end

    test "error tuple with multiple messages" do
      assert [
               %Vx.Error{
                 message: "Something went wrong",
                 actual_value: @invalid_value
               }
             ] =
               Vx.errors_on(
                 force({:error, "Something went wrong"}),
                 @invalid_value
               )
    end

    test "error tuple with multiple messages and paths" do
      assert [
               %Vx.Error{
                 message: "Something went wrong",
                 actual_value: @invalid_value,
                 path: ["foo"]
               },
               %Vx.Error{
                 message: "Another error",
                 actual_value: @invalid_value,
                 path: ["foo", "bar"]
               }
             ] =
               Vx.errors_on(
                 force(
                   {:error,
                    [
                      {["foo"], "Something went wrong"},
                      {["foo", "bar"], "Another error"}
                    ]}
                 ),
                 @invalid_value
               )
    end

    test "error tuple with single error", %{schema: schema} do
      error = %Vx.Error{
        schema: schema,
        message: "Something went wrong",
        actual_value: @invalid_value
      }

      assert Vx.errors_on(force({:error, error}), @invalid_value) == [error]
    end

    test "error tuple with multiple errors", %{schema: schema} do
      errors = [
        %Vx.Error{
          schema: schema,
          message: "Something went wrong",
          actual_value: @invalid_value
        },
        %Vx.Error{
          schema: schema,
          message: "Another error",
          actual_value: @invalid_value,
          path: ["foo", "bar"]
        }
      ]

      assert Vx.errors_on(force({:error, errors}), @invalid_value) == errors
    end
  end

  describe "error_messages_on/2" do
    test "valid", %{schema: schema} do
      assert Vx.error_messages_on(schema, @valid_value) == []
    end

    test "invalid", %{schema: schema} do
      assert Vx.error_messages_on(schema, @invalid_value) == [
               "expected string"
             ]
    end
  end
end
