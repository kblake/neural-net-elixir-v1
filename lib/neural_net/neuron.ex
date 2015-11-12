defmodule NeuralNet.Neuron do
  alias NeuralNet.Neuron,     as: Neuron
  alias NeuralNet.Connection, as: Connection

  defstruct input: 0, output: 0, incoming: [], outgoing: []

  def activation_function(input) do
    1 / (1 + :math.exp(-input))
  end

  defp sumf do
    fn(connection, sum) ->
      sum + connection.source.output * connection.weight
    end
  end

  def activate(neuron, value \\ nil) do
    input = value || Enum.reduce(neuron.incoming, 0, sumf)

    %Neuron{neuron | output: activation_function(input)}
  end

  def connect(source, target) do
    connection = %Connection{source: source, target: target}
    source = %Neuron{source | outgoing: source.outgoing ++ [connection]}
    target = %Neuron{target | incoming: target.incoming ++ [connection]}
    {:ok, source, target}
  end
end
