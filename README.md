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

### Send message.
```elixir
alias ExlChain.LLM
alias ExlChain.LLM.OpenAI

proc = fn ->
  OpenAI.new()
  |> LLM.call("こんにちは！")
end

proc.()
```

### Send message with template.
```elixir
alias ExlChain.LLM
alias ExlChain.LLM.OpenAI
alias ExlChain.Template

proc = fn ->
  template = Template.new(["menu"], "{menu}を作るために必要な材料は")

  OpenAI.new()
  |> LLM.call(template, %{
    "menu" => "カレー"
  })
end

proc.()
```

### Send messages by chain.
```elixir
alias ExlChain.LLM
alias ExlChain.LLM.OpenAI
alias ExlChain.Template
alias ExlChain.Chain

proc = fn ->
  llm = OpenAI.new()
  template1 = Template.new(["product"], "{product}を作る会社の社名として、何かいいものはないですか？")
  template2 = Template.new(["company_name"], "{company_name}という会社名の企業のキャッチコピーを考えてください。")
  params = %{"product" => "カラフルな靴下"}

  Chain.new(params)
  |> Chain.puts("product")
  |> Chain.connect("company_name", fn params ->
    LLM.call(llm, template1, params)
  end)
  |> Chain.puts("company_name")
  |> Chain.connect("catch_copy", fn params ->
    LLM.call(llm, template2, params)
  end)
  |> Chain.puts("catch_copy")
  |> Chain.finish()
end

proc.()
```
