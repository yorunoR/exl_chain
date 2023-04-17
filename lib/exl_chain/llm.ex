defmodule ExlChain.LLM do
  def call(llm, request, content) do
    apply(llm.__struct__, request, [llm, content])
  end

  def call(llm, :chat, template, params) do
    content = template.(params)
    call(llm, :chat, content)
  end
end
