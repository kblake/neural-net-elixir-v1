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

  # test "Create network: hidden layers initialized" do
  #   network = NeuralNet.Network.create([3,2,6,5])
  #   assert length(network.hidden_layers[0]) == 3
  #   assert length(network.hidden_layers[1]) == 6
  # end
end
