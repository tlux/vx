# Vx

[![Build](https://github.com/tlux/vx/actions/workflows/elixir.yml/badge.svg)](https://github.com/tlux/vx/actions/workflows/elixir.yml)
[![Coverage Status](https://coveralls.io/repos/github/tlux/vx/badge.svg?branch=main)](https://coveralls.io/github/tlux/vx?branch=main)
[![Module Version](https://img.shields.io/hexpm/v/vx.svg)](https://hex.pm/packages/vx)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/vx/)
[![License](https://img.shields.io/hexpm/l/vx.svg)](https://github.com/tlux/vx/blob/main/LICENSE.md)
[![Last Updated](https://img.shields.io/github/last-commit/tlux/vx.svg)](https://github.com/tlux/vx/commits/main)

The Elixir schema validator.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `vx` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:vx, "~> 0.1.0"}
  ]
end
```

## Usage

With Vx, you can define schemata to validate complex data against.

You first need to define your schema.

```elixir
schema = Vx.String.t()
```

Then, you can call `Vx.validate/2` or `Vx.validate!`/2` to check if a given
values matches:

```elixir
Vx.validate(schema, "foo")
# :ok
```

When the value does not match, an error is returned (or raised respectively)
pointing out what is wrong:

```elixir
Vx.validate!(schema, 123)
# ** (Vx.Error) must be a string
```

Some types can be augmented with additional constraints by piping everything
together:

```elixir
Vx.Number.t()
|> Vx.Number.gteq(3)
|> Vx.Number.lt(7)
```

You can combine multiple types and constraints to validate more complex
schemata:

```elixir
Vx.Map.shape(%{
  "name" => Vx.String.t(),
  "age" => Vx.Number.t(),
  "hobbies" =>
    Vx.List.t(Vx.String.present())
    |> Vx.List.non_empty(),
  "type" => Vx.Enum.t(["user", "admin"]),
  "addresses" => Vx.List.t(Vx.Struct.t(Address))
})
```

## Docs

Take a look at the [documentation](https://hexdocs.pm/vx) to find out available
types and options.
