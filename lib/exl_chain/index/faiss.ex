defmodule ExlChain.Index.Faiss do
  defstruct name: nil, client: nil

  alias __MODULE__
  alias ExFaiss.Index

  def new(name) do
    %Faiss{
      name: name,
      client: Index.new(1536, "IDMap,Flat", metric: :inner_product)
    }
  end

  def name(index) do
    index.name
  end

  def add(index, args) do
    dataset = Map.get(args, :dataset) |> Nx.tensor()
    ids = Map.get(args, :ids) |> Nx.tensor()
    Index.add_with_ids(index.client, dataset, ids)
  end

  def search(index, args) do
    query = Map.get(args, :query) |> Nx.tensor()
    topK = Map.get(args, :topK)
    Index.search(index.client, query, topK)
  end

  def get_num_vectors(index, _args) do
    Index.get_num_vectors(index.client)
  end
end
