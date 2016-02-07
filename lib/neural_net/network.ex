defmodule NeuralNet.Network do
  defstruct input_layer: [], output_layer: [], hidden_layers: []

  def create(layer_sizes) do
    %NeuralNet.Network{
      input_layer:    extract_input_neurons(layer_sizes),
      output_layer:   extract_output_neurons(layer_sizes),
      hidden_layers:  extract_hidden_neurons(layer_sizes)
    }
  end

  defp extract_input_neurons(layer_sizes) do
    NeuralNet.Layer.init_neurons_by_size(List.first(layer_sizes))
  end

  defp extract_output_neurons(layer_sizes) do
    NeuralNet.Layer.init_neurons_by_size(List.last(layer_sizes))
  end

  defp extract_hidden_neurons(layer_sizes) do
    hidden_layer_sizes = Enum.slice(layer_sizes, 1..length(layer_sizes) - 2)
    Enum.map(hidden_layer_sizes, fn size ->
      NeuralNet.Layer.init_neurons_by_size(size)
    end)
  end

  # def activate do

  # end

  # def connect_layers do
  #   # layers = [
  #   #   [input_layer],
  #   #   hidden_layers,
  #   #   [output_layer]
  #   # ]
  # end
end
