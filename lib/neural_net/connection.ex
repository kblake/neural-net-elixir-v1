defmodule NeuralNet.Connection do
  @doc """
  Represent a connection used by neurons

      iex> connection = %NeuralNet.Connection{}
      ...> connection.weight
      0.4
  """
  defstruct source: %{}, target: %{}, weight: 0.4


  def connection_for(source, target) do
    {:ok, %NeuralNet.Connection{source: source, target: target}}
  end
end
