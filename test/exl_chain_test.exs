defmodule ExlChainTest do
  use ExUnit.Case
  doctest ExlChain

  test "is ok" do
    assert ExlChain.run() == :ok
  end
end
