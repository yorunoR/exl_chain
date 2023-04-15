defmodule ExlChain.LLM.OpenAI do
  defstruct client: nil

  alias __MODULE__
  alias Eoai.Client
  alias Eoai.Request
  alias Eoai.Response

  def new do
    %OpenAI{client: Client.new()}
  end

  def call(llm, content) do
    params = %{
      model: "gpt-3.5-turbo",
      messages: [
        %{role: "user", content: content}
      ]
    }

    Request.call(llm.client, :chat, params)
    |> Response.dig(["choices", 0, "message", "content"])
  end
end
