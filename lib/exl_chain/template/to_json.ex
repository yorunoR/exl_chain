defmodule ExlChain.Template.ToJson do
  def data_key do
    "__to_json__data"
  end

  def keys_key do
    "__to_json__keys"
  end

  def keys do
    [data_key(), keys_key()]
  end

  def template do
    """
      Provide the text delimited by triple backticks into JSON format with the following keys:
      {#{keys_key()}}.


      ```{#{data_key()}}```
    """
  end
end
