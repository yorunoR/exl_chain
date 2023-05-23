defmodule ExlChain.Template.Translate do
  def text_key do
    "__translate__text"
  end

  def lang_key do
    "__translate__lang"
  end

  def keys do
    [text_key(), lang_key()]
  end

  def template do
    """
      Translate the text delimited by triple backticks into {#{lang_key()}}.


      ```{#{text_key()}}```
    """
  end
end
