defmodule Vx.StringTest do
  use ExUnit.Case, async: true

  doctest Vx.String

  @invalid [<<0xFFFF::16>>, nil, :foo, true, false, 123, %{}, []]

  describe "t/0" do
    test "match" do
      assert Vx.validate(Vx.String.t(), "") == :ok
      assert Vx.validate(Vx.String.t(), "foo") == :ok
    end

    test "no match" do
      Enum.each(@invalid, fn value ->
        assert {:error, error} = Vx.validate(Vx.String.t(), value)
        assert Exception.message(error) == "must be a string"
      end)
    end
  end

  describe "non_empty/0" do
    test "match" do
      assert Vx.validate(Vx.String.non_empty(), "foo") == :ok
      assert Vx.validate(Vx.String.non_empty(), "  ") == :ok
      assert Vx.validate(Vx.String.non_empty(), "\n \n") == :ok
    end

    test "no match" do
      assert {:error, error} = Vx.validate(Vx.String.non_empty(), "")
      assert Exception.message(error) == "must not be empty"

      Enum.each(@invalid, fn value ->
        assert {:error, _} = Vx.validate(Vx.String.non_empty(), value)
      end)
    end
  end

  describe "present/0" do
    test "match" do
      assert Vx.validate(Vx.String.present(), "foo") == :ok
    end

    test "no match" do
      Enum.each(["", "   ", "\n \n"], fn value ->
        assert {:error, error} = Vx.validate(Vx.String.present(), value)
        assert Exception.message(error) == "must be present"
      end)

      Enum.each(@invalid, fn value ->
        assert {:error, _} = Vx.validate(Vx.String.present(), value)
      end)
    end
  end

  describe "min_length/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.String.min_length(3), "foo")
      assert :ok = Vx.validate(Vx.String.min_length(3), "foob")
      assert :ok = Vx.validate(Vx.String.min_length(3), "fooba")
    end

    test "no match" do
      assert {:error, error} = Vx.validate(Vx.String.min_length(3), "fo")
      assert Exception.message(error) == "must be at least 3 characters"
    end

    test "invalid size" do
      assert_raise FunctionClauseError, fn ->
        Vx.String.min_length(-1)
      end

      assert_raise FunctionClauseError, fn ->
        Vx.String.min_length(1.1)
      end
    end
  end

  describe "max_length/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.String.max_length(3), "f")
      assert :ok = Vx.validate(Vx.String.max_length(3), "fo")
      assert :ok = Vx.validate(Vx.String.max_length(3), "foo")
    end

    test "no match" do
      assert {:error, error} = Vx.validate(Vx.String.max_length(3), "foob")
      assert Exception.message(error) == "must be at most 3 characters"
    end

    test "invalid size" do
      assert_raise FunctionClauseError, fn ->
        Vx.String.max_length(-1)
      end

      assert_raise FunctionClauseError, fn ->
        Vx.String.max_length(1.1)
      end
    end
  end

  describe "format/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.String.format(~r/\AFOO\z/i), "foo")
    end

    test "no match" do
      assert {:error, error} =
               Vx.validate(Vx.String.format(~r/\AFOO\z/i), "foob")

      assert Exception.message(error) == "must match expected format"
    end
  end
end
