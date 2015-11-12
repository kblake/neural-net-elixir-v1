defmodule Mix.Tasks.Neural do
  use Mix.Task

  def run(args) do
    neuronA = %NeuralNet.Neuron{}
    neuronB = %NeuralNet.Neuron{}

    {:ok, neuronA, neuronB} = NeuralNet.Neuron.connect(neuronA, neuronB)

    neuronA = NeuralNet.Neuron.activate(neuronA)
    IO.puts neuronA.output

    neuronB = NeuralNet.Neuron.activate(neuronB, 1)
    IO.puts neuronB.output
  end
end
