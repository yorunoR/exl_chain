defmodule ExlChain.LLM.OpenAI do
  alias Eoai.Client
  alias Eoai.Request

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
  end

  def call(client, template, params) do
    content = template.(params)
    call(client, content)
  end
end
