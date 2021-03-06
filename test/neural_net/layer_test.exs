defmodule NeuralNet.LayerTest do
  use ExUnit.Case, async: true
  doctest NeuralNet.Layer

  test "defaults layer" do
    NeuralNet.Layer.start_link(:input_layer)
    assert NeuralNet.Layer.neurons(:input_layer) == []
  end

  test "layer initialized with neurons" do
    neurons = [%NeuralNet.Neuron{input: 1}, %NeuralNet.Neuron{input: 2}]
    NeuralNet.Layer.start_link(:input_layer, neurons)
    assert NeuralNet.Layer.neurons(:input_layer) == neurons
  end

  test "add neurons to layer" do
    neurons = [%NeuralNet.Neuron{input: 1}, %NeuralNet.Neuron{input: 2}]
    NeuralNet.Layer.start_link(:input_layer)
    NeuralNet.Layer.add_neurons(:input_layer, neurons)
    assert NeuralNet.Layer.neurons(:input_layer) == neurons
  end

  test "clear neurons from layer" do
    neurons = [%NeuralNet.Neuron{input: 1}, %NeuralNet.Neuron{input: 2}]
    NeuralNet.Layer.start_link(:input_layer, neurons)
    NeuralNet.Layer.clear_neurons(:input_layer)
    assert NeuralNet.Layer.neurons(:input_layer) == []
  end

  test "activate when values are nil" do
    neurons = [%NeuralNet.Neuron{input: 1}, %NeuralNet.Neuron{input: 2}]
    NeuralNet.Layer.start_link(:input_layer, neurons)
    Enum.each NeuralNet.Layer.activate(:input_layer), fn neuron ->
      assert neuron.output == 0.5
    end
  end

  test "activate with values" do
    neurons = [%NeuralNet.Neuron{input: 1}, %NeuralNet.Neuron{input: 2}]
    NeuralNet.Layer.start_link(:input_layer, neurons)
    Enum.each NeuralNet.Layer.activate(:input_layer, [1,2]), fn neuron ->
      assert neuron.output >= 0.0 && neuron.output <= 1.0
    end
  end

  test "input and output layers are connected" do
    input_neurons = [%NeuralNet.Neuron{input: 1}, %NeuralNet.Neuron{input: 2}]
    NeuralNet.Layer.start_link(:input_layer, input_neurons)
    output_neurons = [%NeuralNet.Neuron{input: 3}, %NeuralNet.Neuron{input: 4}, %NeuralNet.Neuron{input: 5}]
    NeuralNet.Layer.start_link(:output_layer, output_neurons)

    {:ok, input_layer_neurons, output_layer_neurons} = NeuralNet.Layer.connect(:input_layer, :output_layer)

    Enum.each input_layer_neurons, fn(neuron) ->
      assert length(neuron.outgoing) == length(output_neurons)
      assert length(neuron.incoming) == 0
      target_neurons = Enum.map neuron.outgoing, fn(connection) -> connection.target end
      assert target_neurons == output_neurons
    end

    Enum.each output_layer_neurons, fn(neuron) ->
      assert length(neuron.incoming) == length(input_neurons)
      assert length(neuron.outgoing) == 0
      source_neurons = Enum.map neuron.incoming, fn(connection) -> connection.source end
      assert source_neurons == input_neurons
    end
  end
end

