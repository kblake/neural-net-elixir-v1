defmodule NeuralNet.Network do
  defstruct input_layer: [], output_layer: [], hidden_layers: []

  def create(layer_sizes) do
    [input_layer_size | tail] = layer_sizes
    input_neurons = NeuralNet.Layer.init_neurons_by_size(input_layer_size)

    output_layer_size = List.last(layer_sizes)
    output_neurons = NeuralNet.Layer.init_neurons_by_size(output_layer_size)
    %NeuralNet.Network{
      input_layer: input_neurons,
      output_layer: output_neurons
    }
  end

  def activate do

  end

  def connect_layers do
    # layers = [
    #   [input_layer],
    #   hidden_layers,
    #   [output_layer]
    # ]
  end
end
