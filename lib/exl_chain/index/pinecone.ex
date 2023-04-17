defmodule ExlChain.Index.Pinecone do
  defstruct client: nil

  alias __MODULE__
  alias Matsukasa.Vector
  alias Matsukasa.VectorClient

  def new(index_name) do
    %Pinecone{
      client: VectorClient.new(index_name)
    }
  end

  def upsert(index, json) do
    Vector.call(index.client, :upsert, json: json)
  end

  def query(index, json) do
    response = Vector.call(index.client, :query, json: json)
    response.body["matches"]
  end
end
