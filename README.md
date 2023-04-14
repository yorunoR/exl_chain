# ExlChain

Something like elixir langChain

**Under development**

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `exl_chain` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:exl_chain, git: "https://github.com/yorunoR/exl_chain.git", tag: "0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/exl_chain>.

## Setup

Prepare configuration file `config/config.exs`.

```elixir
import Config

config :eoai,
  api_key: "your-api-key",
  organization_key: "your-organization-key" # option
```

## Example

Send message.
```elixir
proc = fn ->
  OpenAI.new()
  |> OpenAI.call("こんにちは！")
end

proc.()
```

Send message with template.
```elixir
proc = fn ->
  template = Template.new(["menu"], "{menu}を作るために必要な材料は")

  OpenAI.new()
  |> OpenAI.call(template, %{
    "menu" => "カレー"
  })
end

proc.()
```
