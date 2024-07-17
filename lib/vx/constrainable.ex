defmodule Vx.Constrainable do
  @moduledoc """
  This module can be `use`d in type modules to provide a context-dependent
  `constrain/2` function that checks whether the passed schema matches the using
  module.

  ## Options

  * `:also_permit` - A list of modules that should be permitted as well.
    By default, only the module that `use`d `Vx.Constrainable` is permitted.

  ## Example

      defmodule MyType do
        use Vx.Constrainable

        defstruct []
      end

      iex> %MyType{} |> MyType.constrain(...)
      %Vx.Constrained{}

      iex> %SomeOtherType{} |> MyType.constrain(...)
      ** (Vx.IncompatibleConstraintError) unable to add constraint ...

  To permit `SomeOtherType` from the previous example as well:

      use Vx.Constrainable, also_permit: [SomeOtherType]
  """

  @doc """
  Callback that allows adding constraints limited to a context. The context is
  usually a struct/module.
  """
  @callback constrain(Vx.t(), Vx.t()) :: Vx.t()

  defmacro __using__(opts) do
    also_permitted = List.wrap(opts[:also_permit])

    quote do
      @behaviour unquote(__MODULE__)

      @impl unquote(__MODULE__)
      def constrain(schema, constraint) do
        unquote(__MODULE__).constrain_only(
          schema,
          [__MODULE__ | unquote(also_permitted)],
          constraint
        )
      end
    end
  end

  @doc """
  Adds a constraint to a schema only if the type is one of the expected types.

  ## Examples

      iex> %MyType{} |> Vx.Constrainable.constrain_only(...)
      %Vx.Constrained{}

      iex> %SomeOtherType{} |> Vx.Constrainable.constrain_only(...)
      ** (Vx.IncompatibleConstraintError) unable to add constraint ...
  """
  @spec constrain_only(Vx.t(), module | nonempty_list(module), Vx.t()) :: Vx.t()
  def constrain_only(schema, permitted, constraint) when is_list(permitted) do
    type = type_of(schema)

    unless type in permitted do
      raise %Vx.IncompatibleConstraintError{
        constraint: constraint,
        permitted: permitted,
        actual: type
      }
    end

    Vx.Constrained.t(schema, constraint)
  end

  def constrain_only(schema, permitted, constraint) when is_atom(permitted) do
    constrain_only(schema, [permitted], constraint)
  end

  defp type_of(%Vx.Constrained{schema: %type{}}), do: type
  defp type_of(%type{}), do: type
end
