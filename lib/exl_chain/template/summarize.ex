defmodule ExlChain.Template.Summarize do
  def text_key do
    "__summarize__text"
  end

  def lang_key do
    "__summarize__lang"
  end

  def keys do
    [text_key(), lang_key()]
  end

  def template do
    """
      Summarize the text delimited by triple backticks into a single {#{lang_key()}} sentence.

      ```{#{text_key()}}```
    """
  end
end
