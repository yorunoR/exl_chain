defmodule ExlChain.LLM.OpenAI do
  defstruct client: nil, model: nil

  alias __MODULE__
  alias Eoai.Client
  alias Eoai.Request
  alias Eoai.Response

  def new(model \\ nil) do
    %OpenAI{
      client: Client.new(),
      model: model
    }
  end

  def chat(llm, content) do
    params = %{
      model: llm.model || "gpt-3.5-turbo",
      messages: [
        %{role: "user", content: content}
      ]
    }

    Request.call(llm.client, :chat, params)
    |> Response.dig(["choices", 0, "message", "content"])
  end

  def embeddings(llm, sentence) do
    params = %{
      model: llm.model || "text-embedding-ada-002",
      input: sentence
    }

    response = Request.call(llm.client, :embeddings, params)

    case response.status do
      200 -> Response.dig(response, ["data", 0, "embedding"])
      _ -> IO.inspect(response)
    end
  end
end
