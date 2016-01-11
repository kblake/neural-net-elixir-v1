defmodule NeuralNet.ConnectionTest do
  use ExUnit.Case, async: true
  doctest NeuralNet.Connection

  test "has default values" do
    connection = %NeuralNet.Connection{}
    assert connection.source == %{}
    assert connection.target == %{}
    assert connection.weight == 0.5
  end

  test "assign neurons to source and target" do
    neuronA = %NeuralNet.Neuron{input: 10}
    neuronB = %NeuralNet.Neuron{input: 5}
    connection = %NeuralNet.Connection{source: neuronA, target: neuronB}
    assert connection.source == neuronA
    assert connection.target == neuronB
  end

  test "create a connection for two neurons" do
    neuronA = %NeuralNet.Neuron{input: 10}
    neuronB = %NeuralNet.Neuron{input: 5}
    {:ok, connection} = NeuralNet.Connection.connection_for(neuronA, neuronB)
    assert connection.source == neuronA
    assert connection.target == neuronB
  end
end
