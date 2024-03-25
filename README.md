# Vx

[![Build](https://github.com/tlux/vx/actions/workflows/elixir.yml/badge.svg)](https://github.com/tlux/vx/actions/workflows/elixir.yml)
[![Coverage Status](https://coveralls.io/repos/github/tlux/vx/badge.svg?branch=main)](https://coveralls.io/github/tlux/vx?branch=main)
[![Module Version](https://img.shields.io/hexpm/v/vx.svg)](https://hex.pm/packages/vx)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/vx/)
[![License](https://img.shields.io/hexpm/l/vx.svg)](https://github.com/tlux/vx/blob/main/LICENSE.md)
[![Last Updated](https://img.shields.io/github/last-commit/tlux/vx.svg)](https://github.com/tlux/vx/commits/main)

The Elixir schema validator.

## Installation

The package can be installed by adding `vx` to your list of dependencies in
`mix.exs`:

```elixir
def deps do
  [
    {:vx, "~> 0.1.0"}
  ]
end
```

## Usage

With Vx, you have the capability to define schemata for validating complex data
effortlessly.

First, you need to define your schema.

```elixir
schema = Vx.String.t()
```

After that, you can call `Vx.validate/2` or `Vx.validate!/2` to check if a given
values matches:

```elixir
Vx.validate(schema, "foo")
# :ok
```

When the value does not match, an error is returned (or raised, respectively),
indicating the specific issue.

```elixir
Vx.validate(schema, 123)
# {:error, %Vx.Error{...}}
```

```elixir
Vx.validate!(schema, 123)
# ** (Vx.Error) must be a string
```

Additional constraints can be added to certain types by piping everything
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
