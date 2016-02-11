defmodule NeuralNet.Network do
  defstruct input_layer: [], output_layer: [], hidden_layers: []

  def create(layer_sizes) do
    %NeuralNet.Network{
      input_layer:    input_neurons(layer_sizes),
      output_layer:   output_neurons(layer_sizes),
      hidden_layers:  hidden_neurons(layer_sizes)
    }
  end

  defp input_neurons(layer_sizes) do
    layer_sizes
    |> List.first
    |> NeuralNet.Layer.init_neurons_by_size
  end

  defp output_neurons(layer_sizes) do
    layer_sizes
    |> List.last
    |> NeuralNet.Layer.init_neurons_by_size
  end

  defp hidden_neurons(layer_sizes) do
    layer_sizes
    |> middle_layer_sizes
    |> Enum.map(fn size ->
        NeuralNet.Layer.init_neurons_by_size(size)
       end)
  end

  defp middle_layer_sizes(layer_sizes) do
    layer_sizes
    |> Enum.slice(1..length(layer_sizes) - 2)
  end

  # def activate do

  # end

  def connect_layers(network) do
    layers = layers(network)

    connected_layers = layers
    |> Stream.with_index
    |> Enum.map(fn(tuple) ->
         {layer, index} = tuple
         next_index = index + 1

         if Enum.at(layers, next_index) do
           {:ok, input_layer_neurons, output_layer_neurons} = NeuralNet.Layer.connect(layer, Enum.at(layers, next_index))
           input_layer_neurons
         else # last layer
           {:ok, input_layer_neurons, output_layer_neurons} = NeuralNet.Layer.connect(Enum.at(layers, index - 1), layer)
           output_layer_neurons
         end
       end)

    IO.inspect List.last connected_layers
  end

  defp layers(network) do
    [network.input_layer] ++ network.hidden_layers ++ [network.output_layer]
  end
end
