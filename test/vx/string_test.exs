defmodule Vx.StringTest do
  use ExUnit.Case, async: true

  @invalid [<<0xFFFF::16>>, nil, :foo, true, false, 123, %{}, []]

  describe "t/0" do
    test "match" do
      assert Vx.validate(Vx.String.t(), "") == :ok
      assert Vx.validate(Vx.String.t(), "foo") == :ok
    end

    test "no match" do
      Enum.each(@invalid, fn value ->
        assert {:error,
                %Vx.ValidationError{
                  validator: %Vx.Validator{module: Vx.String, name: nil}
                }} = Vx.validate(Vx.String.t(), value)

        {:error, Vx.ValidationError.new(:string, nil, value)}
      end)
    end
  end

  describe "non_empty/0" do
    test "match" do
      assert Vx.validate(Vx.String.non_empty(), "foo") == :ok
      assert Vx.validate(Vx.String.non_empty(), "  ") == :ok
    end

    test "no match" do
      assert {:error,
              %Vx.ValidationError{
                validator: %Vx.Validator{module: Vx.String, name: :non_empty}
              }} = Vx.validate(Vx.String.non_empty(), "")

      Enum.each(@invalid, fn value ->
        assert {:error,
                %Vx.ValidationError{
                  validator: %Vx.Validator{module: Vx.String, name: nil}
                }} = Vx.validate(Vx.String.non_empty(), value)
      end)
    end
  end

  describe "present/0" do
    test "match" do
      assert Vx.validate(Vx.String.present(), "foo") == :ok
    end

    test "no match" do
      Enum.each(["", "   "], fn value ->
        assert {:error,
                %Vx.ValidationError{
                  validator: %Vx.Validator{module: Vx.String, name: :present},
                  value: ^value
                }} = Vx.validate(Vx.String.present(), value)
      end)

      Enum.each(@invalid, fn value ->
        assert {:error,
                %Vx.ValidationError{
                  validator: %Vx.Validator{module: Vx.String, name: nil},
                  value: ^value
                }} = Vx.validate(Vx.String.present(), value)
      end)
    end
  end
end
