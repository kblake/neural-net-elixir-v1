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

  test "activate when values are nil" do
    neurons = [%NeuralNet.Neuron{input: 1}, %NeuralNet.Neuron{input: 2}]
    NeuralNet.Layer.start_link(:input_layer, neurons) 
    NeuralNet.Layer.activate(:input_layer) 
    Enum.each NeuralNet.Layer.neurons(:input_layer), fn neuron ->
      assert neuron.output == 0.5
    end
  end

  test "activate with values" do
    neurons = [%NeuralNet.Neuron{input: 1}, %NeuralNet.Neuron{input: 2}]
    NeuralNet.Layer.start_link(:input_layer, neurons) 
    NeuralNet.Layer.activate(:input_layer, [1,2]) 
    Enum.each NeuralNet.Layer.neurons(:input_layer), fn neuron ->
      assert neuron.output >= 0.0 && neuron.output <= 1.0
    end
  end
  


  #it "with values" do
    #layer.activate([1,2])
    #layer.neurons.each do |neuron|
    #expect(0.5..1).to cover(neuron.output)
    #end
  #end


  #test "has default values" do
    #layer = %NeuralNet.Layer{}
    #assert layer.neurons == []
  #end

  #test "input layer's outgoing neurons are stored" do
    #input_layer  = %NeuralNet.Layer{neurons: [%NeuralNet.Neuron{input: 1}, %NeuralNet.Neuron{input: 2}]}
    #output_layer = %NeuralNet.Layer{neurons: [%NeuralNet.Neuron{input: 3}, %NeuralNet.Neuron{input: 4}]}

    #{:ok, input_layer, output_layer} = NeuralNet.Layer.connect(input_layer, output_layer)

    #Enum.each input_layer.neurons, fn(neuron) ->
      #assert length(neuron.outgoing) == 2
      #assert length(neuron.incoming) == 0
      ##target_neurons = Enum.map neuron.outgoing, fn(connection) -> connection.target end
      ##assert target_neurons == output_layer.neurons
    #end
  #end

  #it "output layer's incoming neurons + bias neuron are stored" do
    #input_layer.connect(output_layer)

    #output_layer.neurons.each do |neuron|
    #expect(neuron.incoming.size).to eq 3
    #expect(neuron.incoming.map(&:source)).to eq input_layer.neurons
    #expect(neuron.outgoing.size).to eq 0
    #end
  #end
end
