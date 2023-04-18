defmodule ExlChain.Index do
  def call(index, request, opts \\ %{}) do
    apply(index.__struct__, request, [index, opts])
  end
end
