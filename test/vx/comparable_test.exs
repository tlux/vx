defmodule Vx.ComparableTest do
  use ExUnit.Case, async: true

  doctest Vx.Comparable

  @lower_value Version.parse!("1.0.0")
  @upper_value Version.parse!("2.0.0")

  # eq

  describe "eq/2" do
    setup do
      {:ok, schema: Vx.Comparable.eq(@lower_value)}
    end

    test "match", %{schema: schema} do
      assert :ok = Vx.validate(schema, @lower_value)
    end

    test "no match", %{schema: schema} do
      assert {:error, [error]} = Vx.validate(schema, @upper_value)

      assert Exception.message(error) ==
               "must be equal to #{inspect(@lower_value)}"
    end

    test "no match when no struct of expected type", %{schema: schema} do
      assert {:error, [error]} = Vx.validate(schema, "foo")
      assert Exception.message(error) == "expected Version"
    end
  end

  describe "eq/3 with comparable" do
    setup do
      {:ok, schema: Vx.Comparable.eq(Version, @lower_value)}
    end

    test "match", %{schema: schema} do
      assert :ok = Vx.validate(schema, @lower_value)
    end

    test "no match", %{schema: schema} do
      assert {:error, [error]} = Vx.validate(schema, @upper_value)

      assert Exception.message(error) ==
               "must be equal to #{inspect(@lower_value)}"
    end

    test "no match when no struct of expected type", %{schema: schema} do
      assert {:error, [error]} = Vx.validate(schema, "foo")
      assert Exception.message(error) == "expected Version"
    end
  end

  describe "eq/3 with schema" do
    setup do
      {:ok, schema: Vx.Comparable.eq(Vx.Any.t(), @lower_value)}
    end

    test "match", %{schema: schema} do
      assert :ok = Vx.validate(schema, @lower_value)
    end

    test "no match", %{schema: schema} do
      assert {:error, [error]} = Vx.validate(schema, @upper_value)

      assert Exception.message(error) ==
               "must be equal to #{inspect(@lower_value)}"
    end
  end

  describe "eq/4" do
    setup do
      {:ok, schema: Vx.Comparable.eq(Vx.Any.t(), Version, @lower_value)}
    end

    test "match", %{schema: schema} do
      assert :ok = Vx.validate(schema, @lower_value)
    end

    test "no match", %{schema: schema} do
      assert {:error, [error]} = Vx.validate(schema, @upper_value)

      assert Exception.message(error) ==
               "must be equal to #{inspect(@lower_value)}"
    end
  end

  # gt

  describe "gt/2" do
    setup do
      {:ok, schema: Vx.Comparable.gt(@lower_value)}
    end

    test "match", %{schema: schema} do
      assert :ok = Vx.validate(schema, @upper_value)
    end

    test "no match", %{schema: schema} do
      assert {:error, [error]} = Vx.validate(schema, @lower_value)

      assert Exception.message(error) ==
               "must be greater than #{inspect(@lower_value)}"
    end

    test "no match when no struct of expected type", %{schema: schema} do
      assert {:error, [error]} = Vx.validate(schema, "foo")
      assert Exception.message(error) == "expected Version"
    end
  end

  describe "gt/3 with comparable" do
    setup do
      {:ok, schema: Vx.Comparable.gt(Version, @lower_value)}
    end

    test "match", %{schema: schema} do
      assert :ok = Vx.validate(schema, @upper_value)
    end

    test "no match", %{schema: schema} do
      assert {:error, [error]} = Vx.validate(schema, @lower_value)

      assert Exception.message(error) ==
               "must be greater than #{inspect(@lower_value)}"
    end

    test "no match when no struct of expected type", %{schema: schema} do
      assert {:error, [error]} = Vx.validate(schema, "foo")
      assert Exception.message(error) == "expected Version"
    end
  end

  describe "gt/3 with schema" do
    setup do
      {:ok, schema: Vx.Comparable.gt(Vx.Any.t(), @lower_value)}
    end

    test "match", %{schema: schema} do
      assert :ok = Vx.validate(schema, @upper_value)
    end

    test "no match", %{schema: schema} do
      assert {:error, [error]} = Vx.validate(schema, @lower_value)

      assert Exception.message(error) ==
               "must be greater than #{inspect(@lower_value)}"
    end
  end

  describe "gt/4" do
    setup do
      {:ok, schema: Vx.Comparable.gt(Vx.Any.t(), Version, @lower_value)}
    end

    test "match", %{schema: schema} do
      assert :ok = Vx.validate(schema, @upper_value)
    end

    test "no match", %{schema: schema} do
      assert {:error, [error]} = Vx.validate(schema, @lower_value)

      assert Exception.message(error) ==
               "must be greater than #{inspect(@lower_value)}"
    end
  end

  # lt

  describe "lt/2" do
    setup do
      {:ok, schema: Vx.Comparable.lt(@upper_value)}
    end

    test "match", %{schema: schema} do
      assert :ok = Vx.validate(schema, @lower_value)
    end

    test "no match", %{schema: schema} do
      assert {:error, [error]} = Vx.validate(schema, @upper_value)

      assert Exception.message(error) ==
               "must be less than #{inspect(@upper_value)}"
    end

    test "no match when no struct of expected type", %{schema: schema} do
      assert {:error, [error]} = Vx.validate(schema, "foo")
      assert Exception.message(error) == "expected Version"
    end
  end

  describe "lt/3 with comparable" do
    setup do
      {:ok, schema: Vx.Comparable.lt(Version, @upper_value)}
    end

    test "match", %{schema: schema} do
      assert :ok = Vx.validate(schema, @lower_value)
    end

    test "no match", %{schema: schema} do
      assert {:error, [error]} = Vx.validate(schema, @upper_value)

      assert Exception.message(error) ==
               "must be less than #{inspect(@upper_value)}"
    end

    test "no match when no struct of expected type", %{schema: schema} do
      assert {:error, [error]} = Vx.validate(schema, "foo")
      assert Exception.message(error) == "expected Version"
    end
  end

  describe "lt/3 with schema" do
    setup do
      {:ok, schema: Vx.Comparable.lt(Vx.Any.t(), @upper_value)}
    end

    test "match", %{schema: schema} do
      assert :ok = Vx.validate(schema, @lower_value)
    end

    test "no match", %{schema: schema} do
      assert {:error, [error]} = Vx.validate(schema, @upper_value)

      assert Exception.message(error) ==
               "must be less than #{inspect(@upper_value)}"
    end
  end

  describe "lt/4" do
    setup do
      {:ok, schema: Vx.Comparable.lt(Vx.Any.t(), Version, @upper_value)}
    end

    test "match", %{schema: schema} do
      assert :ok = Vx.validate(schema, @lower_value)
    end

    test "no match", %{schema: schema} do
      assert {:error, [error]} = Vx.validate(schema, @upper_value)

      assert Exception.message(error) ==
               "must be less than #{inspect(@upper_value)}"
    end
  end

  # between

  describe "between/2" do
    setup do
      {:ok, schema: Vx.Comparable.between(@lower_value, @upper_value)}
    end

    test "match", %{schema: schema} do
      assert :ok = Vx.validate(schema, Version.parse!("1.2.3"))
    end

    test "no match", %{schema: schema} do
      assert {:error, [error]} = Vx.validate(schema, Version.parse!("0.0.0"))

      assert Exception.message(error) ==
               "must be between #{inspect(@lower_value)} and #{inspect(@upper_value)}"
    end

    test "no match when no struct of expected type", %{schema: schema} do
      assert {:error, [error]} = Vx.validate(schema, "foo")
      assert Exception.message(error) == "expected Version"
    end
  end

  describe "between/3 with comparable" do
    setup do
      {:ok, schema: Vx.Comparable.between(Version, @lower_value, @upper_value)}
    end

    test "match", %{schema: schema} do
      assert :ok = Vx.validate(schema, Version.parse!("1.2.3"))
    end

    test "no match", %{schema: schema} do
      assert {:error, [error]} = Vx.validate(schema, Version.parse!("0.0.0"))

      assert Exception.message(error) ==
               "must be between #{inspect(@lower_value)} and #{inspect(@upper_value)}"
    end

    test "no match when no struct of expected type", %{schema: schema} do
      assert {:error, [error]} = Vx.validate(schema, "foo")
      assert Exception.message(error) == "expected Version"
    end
  end

  describe "between/3 with schema" do
    setup do
      {:ok,
       schema: Vx.Comparable.between(Vx.Any.t(), @lower_value, @upper_value)}
    end

    test "match", %{schema: schema} do
      assert :ok = Vx.validate(schema, Version.parse!("1.2.3"))
    end

    test "no match", %{schema: schema} do
      assert {:error, [error]} = Vx.validate(schema, Version.parse!("0.0.0"))

      assert Exception.message(error) ==
               "must be between #{inspect(@lower_value)} and #{inspect(@upper_value)}"
    end
  end

  describe "between/4" do
    setup do
      {:ok,
       schema:
         Vx.Comparable.between(Vx.Any.t(), Version, @lower_value, @upper_value)}
    end

    test "match", %{schema: schema} do
      assert :ok = Vx.validate(schema, Version.parse!("1.2.3"))
    end

    test "no match", %{schema: schema} do
      assert {:error, [error]} = Vx.validate(schema, Version.parse!("0.0.0"))

      assert Exception.message(error) ==
               "must be between #{inspect(@lower_value)} and #{inspect(@upper_value)}"
    end
  end
end
