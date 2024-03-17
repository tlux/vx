defmodule Vx.TypeTest do
  use ExUnit.Case, async: true

  import Vx.Type

  test "details/1" do
    assert details(Vx.Any.t()) == %{}
    assert details(Vx.List.t()) == %{}
    assert details(Vx.List.t(Vx.String.t())) == %{of: Vx.String.t()}
    assert details(Vx.String.min_length(3)) == %{}

    assert_raise ArgumentError, "expected argument to be a Vx.Type", fn ->
      details(%Country{})
    end
  end

  test "details/2" do
    assert details(Vx.Any.t(), :foo) == %{}
    assert details(Vx.String.max_length(4), :min_length) == %{}
    assert details(Vx.String.min_length(3), :min_length) == %{length: 3}
  end

  describe "validate/2" do
    test "valid" do
      assert validate(Vx.Any.t(), :foo) == :ok
      assert validate(Vx.List.t(), []) == :ok
    end

    test "invalid" do
      assert {:error, error} = validate(Vx.List.t(), "foo")
      assert Exception.message(error) == "must be a list"
    end

    test "invalid argument" do
      assert_raise ArgumentError, "expected argument to be a Vx.Type", fn ->
        validate(%Country{}, "foo")
      end
    end
  end
end
