defmodule Mix.Tasks.Neural do
  use Mix.Task

  @shortdoc "Run the neural network app"

  def run(args) do
    #neuronA = %NeuralNet.Neuron{}
    #neuronB = %NeuralNet.Neuron{}

    #{:ok, neuronA, neuronB} = NeuralNet.Neuron.connect(neuronA, neuronB)

    #neuronA = NeuralNet.Neuron.activate(neuronA)
    #IO.puts neuronA.output

    #neuronB = NeuralNet.Neuron.activate(neuronB, 1)
    #IO.puts neuronB.output

    #layer = %NeuralNet.Layer{neurons: [%NeuralNet.Neuron{}, %NeuralNet.Neuron{}]}
    #IO.inspect layer.neurons

    #inputs = [1,1,1]
    #{:ok, layer} = NeuralNet.Layer.activate(layer, inputs)

    #IO.inspect layer.neurons

    input_layer = %NeuralNet.Layer{neurons: [%NeuralNet.Neuron{}, %NeuralNet.Neuron{}]}
    output_layer = %NeuralNet.Layer{neurons: [%NeuralNet.Neuron{}, %NeuralNet.Neuron{}]}

    {:ok, input_layer, output_layer} = %NeuralNet.Layer.connect(input_layer, output_layer)
  end
end
