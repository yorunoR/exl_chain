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
    {:exl_chain, git: "https://github.com/yorunoR/exl_chain.git", branch: "main"}
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
  api_key: "your-openai-api-key",
  organization_key: "your-organization-key" # option

config :matsukasa,
  api_key: "your-pinecone-api-key",
  environment: "your-environment"
```

Install libraries for ExFaiss.
```
sudo apt-get update
sudo apt-get install libopenblas-dev cmake
```

## Example

### Send message.
```elixir
alias ExlChain.LLM
alias ExlChain.LLM.OpenAI

proc = fn ->
  OpenAI.new()
  |> LLM.call(:chat, "こんにちは！")
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
  |> LLM.call(:chat, template, %{
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
    LLM.call(llm, :chat, template1, params)
  end)
  |> Chain.puts("company_name")
  |> Chain.connect("catch_copy", fn params ->
    LLM.call(llm, :chat, template2, params)
  end)
  |> Chain.puts("catch_copy")
  |> Chain.finish()
end

proc.()
```

### Send messages with built-in template by chain.
```elixir
alias ExlChain.LLM
alias ExlChain.LLM.OpenAI
alias ExlChain.Template
alias ExlChain.Template.Summarize
alias ExlChain.Chain

proc = fn ->
  llm = OpenAI.new(temperature: 0)
  summarize = Template.new(Summarize.keys(), Summarize.template())
  summarize_text_key = Summarize.text_key()
  summarize_lang_key = Summarize.lang_key()

  text = """
  吾輩は猫である。名前はまだ無い。どこで生れたかとんと見当がつかぬ。
  何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。
  吾輩はここで始めて人間というものを見た。
  しかもあとで聞くとそれは書生という人間中で一番獰悪な種族であったそうだ。
  この書生というのは時々我々を捕えて煮て食うという話である。
  しかしその当時は何という考もなかったから別段恐しいとも思わなかった。
  ただ彼の掌に載せられてスーと持ち上げられた時何だかフワフワした感じがあったばかりである。
  掌の上で少し落ちついて書生の顔を見たのがいわゆる人間というものの見始であろう。
  この時妙なものだと思った感じが今でも残っている。
  第一毛をもって装飾されべきはずの顔がつるつるしてまるで薬缶だ。
  その後猫にもだいぶ逢ったがこんな片輪には一度も出会わした事がない。
  のみならず顔の真中があまりに突起している。
  """

  params = %{
    summarize_text_key => text,
    summarize_lang_key => "Japanese"
  }

  Chain.new(params)
  |> Chain.connect("result", fn params ->
    LLM.call(llm, :chat, summarize, params)
  end)
  |> Chain.drop([summarize_text_key, summarize_lang_key])
  |> Chain.finish()
end

proc.()
```

### Save your text to pinecone index.
```elixir
alias ExlChain.LLM
alias ExlChain.LLM.OpenAI
alias ExlChain.Index
alias ExlChain.Index.Pinecone

proc = fn ->
  namespace = "your_namespace"

  sentences =
    File.read!("your_text_file")
    |> String.split("your_separator")
    |> Enum.map(fn sentence -> String.replace(sentence, "\n", "") end)

  llm = OpenAI.new("text-embedding-ada-002")
  index = Pinecone.new("your_pinecone_index")

  sentences
  |> Enum.with_index(1)
  |> Enum.each(fn {sentence, i} ->
    # to avoid access limit
    :timer.sleep(200)

    IO.inspect(sentence)

    values = LLM.call(llm, :embeddings, sentence)

    json = %{
      vectors: %{
        id: to_string(i),
        values: values,
        metadata: %{sentence: sentence}
      },
      namespace: namespace
    }

    Index.call(index, :upsert, json)
  end)
end

proc.()
```

### Get sentences from pinecone index.
```elixir
alias ExlChain.LLM
alias ExlChain.LLM.OpenAI
alias ExlChain.Index
alias ExlChain.Index.Pinecone

proc = fn ->
  namespace = "your_namespace"
  question = "your_question"

  llm = OpenAI.new("text-embedding-ada-002")
  index = Pinecone.new("your_pinecone_index")

  vector = LLM.call(llm, :embeddings, question)

  json = %{
    namespace: namespace,
    includeValues: false,
    includeMetadata: true,
    topK: 10,
    vector: vector
  }

  Index.call(index, :query, json)
  |> Enum.sort_by(&(&1["score"]))
end

proc.()
```

### Your text with faiss index.
```elixir
alias ExlChain.LLM
alias ExlChain.LLM.OpenAI
alias ExlChain.Index
alias ExlChain.Index.Faiss

proc = fn ->
  sentences =
    File.read!("your_text_file")
    |> String.split("your_separator")
    |> Enum.map(fn sentence -> String.replace(sentence, "\n", "") end)

  llm = OpenAI.new("text-embedding-ada-002")
  index = Faiss.new("your_index_name")

  sentences
  |> Enum.with_index(0)
  |> Enum.each(fn {sentence, i} ->
    # For access limit
    :timer.sleep(400)

    IO.inspect(sentence)

    values = LLM.call(llm, :embeddings, sentence)

    json = %{
      dataset: [values],
      ids: [i]
    }

    Index.call(index, :add, json)
  end)

  IO.puts("\n--- Saved your text ---\n")

  question = "your_question" |> IO.inspect()

  query = LLM.call(llm, :embeddings, question)

  json = %{
    query: query,
    topK: 10
  }

  response = Index.call(index, :search, json)

  IO.puts("\n--- Result ---\n")

  response.labels
  |> Nx.to_flat_list()
  |> IO.inspect()
  |> Enum.each(fn index ->
    Enum.at(sentences, index) |> IO.inspect()
  end)
end

proc.()
```
