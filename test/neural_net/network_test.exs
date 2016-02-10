defmodule NeuralNet.NetworkTest do
  use ExUnit.Case, async: true
  doctest NeuralNet.Network

  test "Create network: input layer initialized" do
    network = NeuralNet.Network.create([3,2,5])
    assert length(network.input_layer) == 3
  end

  test "Create network: output layer initialized" do
    network = NeuralNet.Network.create([3,2,5])
    assert length(network.output_layer) == 5
  end

  test "Create network: hidden layers initialized" do
    network = NeuralNet.Network.create([3,2,6,5])
    assert length(List.first(network.hidden_layers)) == 2
    assert length(List.last(network.hidden_layers)) == 6
  end

  test "Connect layers in network" do
    network = NeuralNet.Network.create([3,2,5])
    NeuralNet.Network.connect_layers(network)
  end
end
