defmodule ExlChain.LLM.OpenAI do
  defstruct client: nil, model: nil, temperature: nil

  alias __MODULE__
  alias Eoai.Client
  alias Eoai.Request
  alias Eoai.Response

  def new() do
    %OpenAI{
      client: Client.new()
    }
  end

  def new(model) when is_binary(model) do
    %OpenAI{
      client: Client.new(),
      model: model
    }
  end

  def new(opts) when is_list(opts) do
    model = Keyword.get(opts, :model)
    temperature = Keyword.get(opts, :temperature)

    %OpenAI{
      client: Client.new(),
      model: model,
      temperature: temperature
    }
  end

  def chat(llm, content) do
    params = %{
      model: llm.model || "gpt-3.5-turbo",
      temperature: llm.temperature || 1,
      messages: [
        %{role: "user", content: content}
      ]
    }

    Request.call(llm.client, :chat, params)
    |> Response.dig!(["choices", 0, "message", "content"])
  end

  def embeddings(llm, sentence) do
    params = %{
      model: llm.model || "text-embedding-ada-002",
      input: sentence
    }

    response = Request.call(llm.client, :embeddings, params)

    case response.status do
      200 -> Response.dig!(response, ["data", 0, "embedding"])
      _ -> IO.inspect(response)
    end
  end
end
