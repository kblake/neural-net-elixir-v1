defmodule NeuralNet.Neuron do
  alias NeuralNet.Neuron,     as: Neuron
  alias NeuralNet.Connection, as: Connection

  defstruct input: 0, output: 0, incoming: [], outgoing: []

  @doc """
  Sigmoid function. See more at: https://en.wikipedia.org/wiki/Sigmoid_function

  ## Example

      iex> NeuralNet.Neuron.activation_function(1)
      0.7310585786300049
  """
  def activation_function(input) do
    1 / (1 + :math.exp(-input))
  end

  defp sumf do
    fn(connection, sum) ->
      sum + connection.source.output * connection.weight
    end
  end

  @doc """
  Activate a neuron

  ## Activate with specified value
      iex> neuron = NeuralNet.Neuron.activate(%NeuralNet.Neuron{}, 1)
      ...> neuron.output
      0.7310585786300049

  ## Activate with no incoming connections
      iex> neuron = NeuralNet.Neuron.activate(%NeuralNet.Neuron{})
      ...> neuron.output
      0.5

  ## Activate with incoming connections
      iex> neuron = %NeuralNet.Neuron{ incoming: [ %NeuralNet.Connection{source: %NeuralNet.Neuron{output: 6}} ] }
      ...> neuron = NeuralNet.Neuron.activate(neuron)
      ...> neuron.output
      0.9168273035060777
  """
  def activate(neuron, value \\ nil) do
    input = value || Enum.reduce(neuron.incoming, 0, sumf)
    %Neuron{neuron | output: activation_function(input)}
  end

  @doc """
  Connect two neurons

  ## Example

      iex> neuronA = %NeuralNet.Neuron{ outgoing: [%NeuralNet.Connection{}] }
      ...> neuronB = %NeuralNet.Neuron{ incoming: [%NeuralNet.Connection{}] }
      ...> {:ok, neuronA, neuronB} = NeuralNet.Neuron.connect(neuronA, neuronB)
      ...> length(neuronA.outgoing)
      2
      iex> length(neuronB.incoming)
      2
  """
  def connect(source, target) do
    {:ok, connection} = Connection.connection_for(source, target)
    source = %Neuron{source | outgoing: source.outgoing ++ [connection]}
    target = %Neuron{target | incoming: target.incoming ++ [connection]}
    {:ok, source, target}
  end
end
