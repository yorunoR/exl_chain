defmodule ExlChain.LLM do
  def call(llm, content) do
    apply(llm.__struct__, :call, [llm, content])
  end

  def call(llm, template, params) do
    content = template.(params)
    call(llm, content)
  end
end
