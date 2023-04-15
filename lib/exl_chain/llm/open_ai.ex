defmodule ExlChain.LLM.OpenAI do
  alias Eoai.Client
  alias Eoai.Request
  alias Eoai.Response

  def new do
    Client.new()
  end

  def call(client, content) do
    params = %{
      model: "gpt-3.5-turbo",
      messages: [
        %{role: "user", content: content}
      ]
    }

    Request.call(client, :chat, params)
    |> Response.dig(["choices", 0, "message", "content"])
  end

  def call(client, template, params) do
    content = template.(params)
    call(client, content)
  end
end
