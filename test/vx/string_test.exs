defmodule Vx.StringTest do
  use ExUnit.Case, async: true

  alias Vx.Schema

  @invalid [<<0xFFFF::16>>, nil, :foo, true, false, 123, %{}, []]

  test "t/0" do
    assert Schema.eval(Vx.String.t(), "") == :ok
    assert Schema.eval(Vx.String.t(), "foo") == :ok

    Enum.each(@invalid, fn value ->
      assert Schema.eval(Vx.String.t(), value) ==
               {:error, Vx.TypeError.new(:string, nil, value)}
    end)
  end

  test "non_empty/0" do
    assert Schema.eval(Vx.String.non_empty(), "foo") == :ok

    assert Schema.eval(Vx.String.non_empty(), "") ==
             {:error, Vx.TypeError.new(:string, :non_empty, "")}

    assert Schema.eval(Vx.String.non_empty(), "  ") == :ok

    Enum.each(@invalid, fn value ->
      assert Schema.eval(Vx.String.t(), value) ==
               {:error, Vx.TypeError.new(:string, nil, value)}
    end)
  end

  test "present/0" do
    assert Schema.eval(Vx.String.present(), "foo") == :ok

    Enum.each(["", "   "], fn value ->
      assert Schema.eval(Vx.String.present(), value) ==
               {:error, Vx.TypeError.new(:string, :present, value)}
    end)

    Enum.each(@invalid, fn value ->
      assert Schema.eval(Vx.String.t(), value) ==
               {:error, Vx.TypeError.new(:string, nil, value)}
    end)
  end
end
