defmodule Vx.ConstrainContextual do
  @moduledoc """
  This module can be `use`d in type modules to provide a context-dependent
  `constrain/2` function that checks whether the passed schema matches the using
  module.

  ## Options

  * `:also_permit` - A list of modules that should be permitted as well.
    By default, only the current module is.

  ## Example

      defmodule MyType do
        use Vx.ConstrainContextual

        defstruct []
      end

      iex> %MyType{} |> MyType.constrain(...)
      :ok

      iex> %SomeOtherType{} |> MyType.constrain(...)
      ** (Vx.IncompatibleConstraintError) unable to add constraint ...

  To permit `SomeOtherType` from the previous example as well:

      use Vx.ConstrainContextual, also_permit: [SomeOtherType]
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
        Vx.Constrain.constrain_only(
          schema,
          [__MODULE__ | unquote(also_permitted)],
          constraint
        )
      end
    end
  end
end
