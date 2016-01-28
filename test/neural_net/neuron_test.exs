defmodule NeuralNet.NeuronTest do
  use ExUnit.Case, async: true
  doctest NeuralNet.Neuron

  test "has default values" do
    neuron = %NeuralNet.Neuron{}
    assert neuron.input == 0
    assert neuron.output == 0
    assert neuron.incoming == []
    assert neuron.outgoing == []
  end

  test ".activation_function" do
    assert NeuralNet.Neuron.activation_function(1) == 0.7310585786300049
  end

  test ".activate with specified value" do
    neuron = NeuralNet.Neuron.activate(%NeuralNet.Neuron{}, 1)
    assert neuron.output == 0.7310585786300049
  end

  test ".activate with no incoming connections" do
    neuron = NeuralNet.Neuron.activate(%NeuralNet.Neuron{})
    assert neuron.output == 0.5
  end

  test ".activate with incoming connections" do
    neuron = %NeuralNet.Neuron{
      incoming: [
        %NeuralNet.Connection{source: %NeuralNet.Neuron{output: 2}},
        %NeuralNet.Connection{source: %NeuralNet.Neuron{output: 5}}
      ]
    }
    neuron = NeuralNet.Neuron.activate(neuron)
    assert neuron.output == 0.9426758241011313
  end

  test ".connect" do
    neuronA = %NeuralNet.Neuron{ outgoing: [%NeuralNet.Connection{}] }
    neuronB = %NeuralNet.Neuron{ incoming: [%NeuralNet.Connection{}] }

    {:ok, neuronA, neuronB} = NeuralNet.Neuron.connect(neuronA, neuronB)

    assert length(neuronA.outgoing) == 2
    assert length(neuronB.incoming) == 2
  end
end
