defmodule ExlChain.Index do
  def call(index, request, params \\ %{}) do
    apply(index.__struct__, request, [index, params])
  end
end
