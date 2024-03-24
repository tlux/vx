defmodule Vx.MapTest do
  use ExUnit.Case, async: true

  doctest Vx.Map

  @invalid ["", <<0xFFFF::16>>, nil, :foo, true, false, 123, []]

  describe "t/0" do
    test "match" do
      assert :ok = Vx.validate(Vx.Map.t(), %{})
      assert :ok = Vx.validate(Vx.Map.t(), %{"foo" => "bar"})
    end

    test "no match" do
      Enum.each(@invalid, fn value ->
        assert {:error, error} = Vx.validate(Vx.Map.t(), value)
        assert Exception.message(error) == "must be a map"
      end)
    end
  end

  describe "t/2" do
    test "match" do
      assert :ok =
               Vx.validate!(Vx.Map.t(Vx.String.t(), Vx.Number.t()), %{
                 "foo" => 123,
                 "bar" => 234.5
               })

      schema = Vx.Map.t(Vx.Atom.t(), Vx.Union.t([Vx.Number.t(), Vx.String.t()]))

      assert :ok = Vx.validate!(schema, %{foo: 123, bar: "baz"})
      assert :ok = Vx.validate!(schema, %{bar: "baz"})
      assert :ok = Vx.validate!(schema, %{foo: 123, bar: 234})
    end

    test "no match" do
      schema = Vx.Map.t(Vx.String.t(), Vx.Number.t())

      assert {:error, error} =
               Vx.validate(schema, %{:foo => 123, "bar" => 234.5})

      assert Exception.message(error) ==
               "must be a map<string, number>\n" <>
                 "- element :foo: must be a string"

      assert {:error, error} = Vx.validate(schema, %{"foo" => "bar"})

      assert Exception.message(error) ==
               "must be a map<string, number>\n" <>
                 ~s[- value of element "foo": must be a number]

      assert {:error, _} = Vx.validate(schema, %{"foo" => 123, "bar" => "bar"})

      assert {:error, error} = Vx.validate(schema, "foo")
      assert Exception.message(error) == "must be a map<string, number>"
    end
  end

  describe "shape/1" do
    test "missing required key" do
      assert {:error, error} =
               Vx.validate(Vx.Map.shape(%{"foo" => "bar", "bar" => 123}), %{})

      assert Exception.message(error) == ~s[must have key(s) "bar", "foo"]
    end

    test "exact key and value" do
      assert :ok =
               Vx.validate!(Vx.Map.shape(%{"foo" => "bar"}), %{"foo" => "bar"})

      assert {:error, error} =
               Vx.validate(Vx.Map.shape(%{"foo" => "bar"}), %{"foo" => "baz"})

      assert Exception.message(error) ==
               "does not match shape\n" <>
                 ~s[- key "foo": must be "bar"]
    end

    test "schema value" do
      assert :ok =
               Vx.validate!(Vx.Map.shape(%{"foo" => Vx.String.t()}), %{
                 "foo" => "bar"
               })

      assert {:error, error} =
               Vx.validate(Vx.Map.shape(%{"foo" => Vx.String.present()}), %{
                 "foo" => " "
               })

      assert Exception.message(error) ==
               "does not match shape\n" <>
                 ~s[- key "foo": must be present]
    end

    test "optional key" do
      shape =
        Vx.Map.shape(%{
          Vx.Optional.t("foo") => Vx.String.t(),
          "bar" => Vx.Number.t(),
          "baz" => Vx.Optional.t(Vx.String.t())
        })

      assert :ok =
               Vx.validate!(shape, %{
                 "foo" => "baz",
                 "bar" => 234,
                 "baz" => "foo"
               })

      assert :ok = Vx.validate!(shape, %{"bar" => 234, "baz" => "foo"})

      assert {:error, error} =
               Vx.validate(shape, %{
                 "foo" => "baz",
                 "bar" => 234,
                 "baz" => "foo",
                 "qix" => "hey"
               })

      assert Exception.message(error) == ~s[must not have key(s) "qix"]

      assert {:error, error} =
               Vx.validate(shape, %{"foo" => "baz", "baz" => "foo"})

      assert Exception.message(error) == ~s[must have key(s) "bar"]

      assert {:error, error} =
               Vx.validate(shape, %{
                 "foo" => "baz",
                 "bar" => 123
               })

      assert Exception.message(error) == ~s[must have key(s) "baz"]

      assert :ok =
               Vx.validate!(shape, %{
                 "foo" => "baz",
                 "bar" => 123,
                 "baz" => nil
               })

      assert {:error, error} =
               Vx.validate(shape, %{
                 "foo" => 123,
                 "bar" => 234,
                 "baz" => "foo"
               })

      assert Exception.message(error) ==
               "does not match shape\n" <>
                 ~s[- key "foo": must be a string]
    end

    test "excess keys" do
      shape = Vx.Map.shape(%{"foo" => Vx.Number.t()})

      assert {:error, error} =
               Vx.validate(shape, %{
                 "foo" => 123,
                 "bar" => "baz",
                 "baz" => "qix"
               })

      assert Exception.message(error) == ~s[must not have key(s) "bar", "baz"]
    end

    test "ambiguous keys" do
      assert_raise ArgumentError,
                   ~s[key(s) "baz", "foo" must not be defined as ] <>
                     "required and optional at the same time",
                   fn ->
                     Vx.validate(
                       Vx.Map.shape(%{
                         "foo" => Vx.String.t(),
                         Vx.Optional.t("foo") => Vx.Integer.t(),
                         "bar" => Vx.String.t(),
                         "baz" => Vx.String.t(),
                         Vx.Optional.t("baz") => Vx.Integer.t()
                       }),
                       %{"foo" => "bar"}
                     )
                   end
    end
  end

  describe "size/1" do
    test "match" do
      assert :ok = Vx.validate(Vx.Map.size(0), %{})
      assert :ok = Vx.validate(Vx.Map.size(1), %{"foo" => "bar"})
    end

    test "no match" do
      assert {:error, error} =
               Vx.validate(Vx.Map.size(1), %{"foo" => "bar", "baz" => "qix"})

      assert Exception.message(error) == "must have size of 1"
    end

    test "invalid size" do
      assert_raise FunctionClauseError, fn ->
        Vx.Map.size(-1)
      end

      assert_raise FunctionClauseError, fn ->
        Vx.Map.size(1.1)
      end
    end
  end
end
