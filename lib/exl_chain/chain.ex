defmodule ExlChain.Chain do
  defstruct params: nil

  alias __MODULE__

  def new(params \\ %{}) do
    IO.puts("=== New ===")

    %Chain{
      params: params
    }
  end

  def puts(chain, key) do
    IO.puts("#{key}: #{Map.get(chain.params, key)}")
    chain
  end

  def connect(chain, output_key, func) do
    result = func.(chain.params)

    chain
    |> deep_merge(%{
      params: %{
        output_key => result
      }
    })
  end

  def finish(chain) do
    IO.puts("=== End ===")
    chain.params
  end

  defp deep_merge(map1, map2) when is_map(map1) and is_map(map2) do
    Map.merge(map1, map2, fn _key, value1, value2 -> deep_merge(value1, value2) end)
  end

  defp deep_merge(_not_map1, not_map2), do: not_map2
end
