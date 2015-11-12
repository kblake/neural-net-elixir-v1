defmodule NeuralNet.NeuronTest do
  use ExUnit.Case
  doctest NeuralNet.Neuron

  test "has default values" do
    neuron = %NeuralNet.Neuron{}
    assert neuron.input == 0
    assert neuron.output == 0
    assert neuron.incoming == []
    assert neuron.outgoing == []
  end

  #test ".activation_function"
  #test ".activate"
  #test ".connect"
end
