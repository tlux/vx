defmodule Vx.StringTest do
  use ExUnit.Case, async: true

  @invalid [<<0xFFFF::16>>, nil, :foo, true, false, 123, %{}, []]

  test "t/0" do
    assert Vx.validate(Vx.String.t(), "") == :ok
    assert Vx.validate(Vx.String.t(), "foo") == :ok

    Enum.each(@invalid, fn value ->
      assert {:error,
              %Vx.TypeError{
                validator: %Vx.Validator{type: Vx.String, name: nil}
              }} = Vx.validate(Vx.String.t(), value)

      {:error, Vx.TypeError.new(:string, nil, value)}
    end)
  end

  test "non_empty/0" do
    assert Vx.validate(Vx.String.non_empty(), "foo") == :ok

    assert {:error,
            %Vx.TypeError{
              validator: %Vx.Validator{type: Vx.String, name: :non_empty}
            }} = Vx.validate(Vx.String.non_empty(), "")

    assert Vx.validate(Vx.String.non_empty(), "  ") == :ok

    Enum.each(@invalid, fn value ->
      assert {:error,
              %Vx.TypeError{
                validator: %Vx.Validator{type: Vx.String, name: nil}
              }} = Vx.validate(Vx.String.non_empty(), value)
    end)
  end

  test "present/0" do
    assert Vx.validate(Vx.String.present(), "foo") == :ok

    Enum.each(["", "   "], fn value ->
      assert {:error,
              %Vx.TypeError{
                validator: %Vx.Validator{type: Vx.String, name: :present},
                value: ^value
              }} = Vx.validate(Vx.String.present(), value)
    end)

    Enum.each(@invalid, fn value ->
      assert {:error,
              %Vx.TypeError{
                validator: %Vx.Validator{type: Vx.String, name: nil},
                value: ^value
              }} = Vx.validate(Vx.String.present(), value)
    end)
  end
end
