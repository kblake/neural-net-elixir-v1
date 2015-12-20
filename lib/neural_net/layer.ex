defmodule NeuralNet.Layer do
  defstruct neurons: []
  
  def activate(layer, values \\ nil) do
    values = values || []

    activated_neurons = layer.neurons
                        |> Stream.with_index
                        |> Enum.map(fn(tuple) ->
                                        {neuron, index} = tuple
                                        NeuralNet.Neuron.activate(neuron, values[index])
                                     end)

    {:ok, %NeuralNet.Layer{neurons: activated_neurons}}
  end

  #def connect(target_layer) do

  #end
end
