defmodule OpenaiEx.Embeddings do
  @moduledoc """
  This module provides an implementation of the OpenAI embeddings API. The API reference can be found at https://platform.openai.com/docs/api-reference/embeddings.
  """
  alias OpenaiEx.Http

  @api_fields [
    :input,
    :model,
    :dimensions,
    :encoding_format,
    :user
  ]

  @doc """
  Creates a new embedding request with the given arguments.

  ## Arguments

  - `args`: A list of key-value pairs, or a map, representing the fields of the embedding request.

  ## Returns

  A map containing the fields of the embedding request.

  The `:model` and `:input` fields are required.

  Example usage:

      iex> _request = OpenaiEx.Embeddings.new(model: "text-embedding-ada-002", input: "This is a test")
      %{input: "This is a test", model: "text-embedding-ada-002"}

      iex> _request = OpenaiEx.Embeddings.new(%{model: "text-embedding-ada-002", input: "This is a test"})
      %{input: "This is a test", model: "text-embedding-ada-002"}
  """

  def new(args = [_ | _]) do
    args |> Enum.into(%{}) |> new()
  end

  def new(args = %{model: _, input: _}) do
    args |> Map.take(@api_fields)
  end

  @ep_url "/embeddings"

  @doc """
  Calls the embedding endpoint.

  ## Arguments

  - `openai`: The OpenAI configuration to use.
  - `embedding`: The embedding request to send.

  ## Returns

  A map containing the fields of the embedding response.

  See https://platform.openai.com/docs/api-reference/embeddings/create for more information.
  """
  def create!(openai = %OpenaiEx{}, embedding = %{}) do
    openai |> create(embedding) |> Http.bang_it!()
  end

  def create(openai = %OpenaiEx{}, embedding = %{}) do
    ep = Map.get(openai, :_ep_path_mapping).(@ep_url)
    openai |> Http.post(ep, json: embedding)
  end
end
