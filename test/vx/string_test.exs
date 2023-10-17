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

  test "nonempty/0" do
    assert Schema.eval(Vx.String.nonempty(), "foo") == :ok

    assert Schema.eval(Vx.String.nonempty(), "") ==
             {:error, Vx.TypeError.new(:string, :nonempty, "")}

    assert Schema.eval(Vx.String.nonempty(), "  ") == :ok

    Enum.each(@invalid, fn value ->
      assert Schema.eval(Vx.String.t(), value) ==
               {:error, Vx.TypeError.new(:string, nil, value)}
    end)
  end

  test "nonblank/0" do
    assert Schema.eval(Vx.String.nonblank(), "foo") == :ok

    Enum.each(["", "   "], fn value ->
      assert Schema.eval(Vx.String.nonblank(), value) ==
               {:error, Vx.TypeError.new(:string, :nonblank, value)}
    end)

    Enum.each(@invalid, fn value ->
      assert Schema.eval(Vx.String.t(), value) ==
               {:error, Vx.TypeError.new(:string, nil, value)}
    end)
  end
end
