defmodule Vx.Type do
  @moduledoc """
  A basic type that implements the `Vx.Validatable` protocol and allows adding
  constraints to the type definition.
  """

  alias Vx.Constraint

  @enforce_keys [:name, :fun]
  defstruct [:name, :fun, of: [], constraints: []]

  @type fun :: (any -> :ok | {:error, String.t()})

  @type t(name) :: %__MODULE__{
          name: name,
          of: [any],
          fun: fun,
          constraints: [Constraint.t()]
        }

  @type t :: t(atom)

  @type custom(mod, name) :: %{
          :__struct__ => mod,
          :__type__ => t(name),
          optional(atom) => any
        }

  @doc """
  Creates a new type.
  """
  @spec new(name, [any], fun) :: t(name) when name: atom
  def new(name, of \\ [], fun) when is_list(of) and is_function(fun, 1) do
    %__MODULE__{name: name, of: of, fun: fun}
  end

  @doc """
  Adds a constraint to the type.
  """
  @spec constrain(type, atom, any, Constraint.fun()) :: type
        when type: t(atom) | custom(module, atom)
  def constrain(type, name, value \\ nil, fun) when is_function(fun, 1) do
    update(type, fn type ->
      %{
        type
        | constraints: [Constraint.new(name, value, fun) | type.constraints]
      }
    end)
  end

  @doc """
  Returns the constraints of the type.
  """
  @spec constraints(type) :: [Constraint.t()]
        when type: t(atom) | custom(module, atom)
  def constraints(type) do
    type
    |> resolve()
    |> Map.fetch!(:constraints)
    |> Enum.reverse()
  end

  @doc """
  Returns the constraints of the type with the given name.
  """
  @doc since: "0.4.0"
  @spec constraints(type, atom) :: [Constraint.t()]
        when type: t(atom) | custom(module, atom)
  def constraints(type, name) do
    type
    |> constraints()
    |> Enum.filter(&match?(%Constraint{name: ^name}, &1))
  end

  defp resolve(%{__type__: %__MODULE__{} = type}), do: type
  defp resolve(%__MODULE__{} = type), do: type

  defp update(%{__type__: %__MODULE__{} = resolved} = type, fun)
       when is_function(fun, 1) do
    %{type | __type__: fun.(resolved)}
  end

  defp update(%__MODULE__{} = type, fun) when is_function(fun, 1) do
    fun.(type)
  end

  defimpl Vx.Validatable do
    def validate(%{fun: fun} = type, value) do
      case fun.(value) do
        :ok ->
          validate_constraints(type, value)

        {:error, message} ->
          {:error, message}
      end
    end

    defp validate_constraints(type, value) do
      type
      |> Vx.Type.constraints()
      |> Enum.reduce_while(:ok, fn constraint, _acc ->
        case Vx.Constraint.validate(constraint, value) do
          :ok -> {:cont, :ok}
          {:error, _} = error -> {:halt, error}
        end
      end)
    end
  end

  defimpl Vx.Inspectable do
    def inspect(type) do
      Kernel.to_string(type.name) <>
        of_string(type.of) <>
        constraints_string(Vx.Type.constraints(type))
    end

    defp of_string([]), do: ""

    defp of_string(of) do
      "<" <> Vx.Util.inspect_enum(of, &Vx.Inspectable.inspect/1) <> ">"
    end

    defp constraints_string([]), do: ""

    defp constraints_string(constraints) do
      "(" <> Vx.Util.inspect_enum(constraints, &Constraint.to_string/1) <> ")"
    end
  end

  @doc """
  Turns a module into a custom type. It automatically implements the
  `Vx.Validatable` and `Vx.Inspectable` protocols for the newly created type and
  allows easily chaining constraints on your type.

  ## Example

      defmodule MyType do
        use Vx.Type, :my_type

        # The type constructor
        @spec t() :: t
        def t do
          new(fn value ->
            if my_type_is_valid?(value) do
              :ok
            else
              {:error, "my type is not valid"}
            end
          end)
        end

        # A function that adds a constraint to a type
        @spec foo(t) :: t
        def foo(%__MODULE__{} = type \\\\ t()) do
          constrain(type, :my_constraint, fn value ->
            if value < 123, do: :ok, else: {:error, "must be less than 123"}
          end)
        end

        # ...
      end
  """
  defmacro __using__(name) when is_atom(name) do
    quote location: :keep do
      @enforce_keys [:__type__]
      defstruct [:__type__]

      @typedoc """
      The #{unquote(name)} type.
      """
      @opaque t :: Vx.Type.custom(__MODULE__, unquote(name))

      defp new(of \\ [], fun) do
        %__MODULE__{__type__: Vx.Type.new(unquote(name), of, fun)}
      end

      defp constrain(schema, name, value \\ nil, fun) do
        Vx.Type.constrain(schema, name, value, fun)
      end

      defimpl Vx.Validatable do
        def validate(%{__type__: type}, value) do
          Vx.Validatable.validate(type, value)
        end
      end

      defimpl Vx.Inspectable do
        def inspect(%{__type__: type}) do
          Vx.Inspectable.inspect(type)
        end
      end
    end
  end
end
