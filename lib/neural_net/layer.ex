defmodule NeuralNet.Layer do

  def start_link(layer_name, neurons \\ []) do
    Agent.start_link(fn -> neurons end, name: layer_name)
  end

  def neurons(layer_name) do
    Agent.get(layer_name, (&(&1)))
  end

  def add_neurons(layer_name, neurons) do
    Agent.update(layer_name, &(&1 ++ neurons))
  end

  def activate(layer_name, values \\ nil) do
    values = values || []

    Agent.update(layer_name, fn neurons ->
      neurons
      |> Stream.with_index
      |> Enum.map(fn(tuple) ->
        {neuron, index} = tuple
        NeuralNet.Neuron.activate(neuron, Enum.at(values, index))
      end)
    end)
  end




  #defstruct neurons: []

  #def activate(layer, values \\ nil) do
    #values = values || []

    #activated_neurons = layer.neurons
                        #|> Stream.with_index
                        #|> Enum.map(fn(tuple) ->
                                        #{neuron, index} = tuple
                                        #NeuralNet.Neuron.activate(neuron, values[index])
                                     #end)

    #{:ok, %NeuralNet.Layer{neurons: activated_neurons}}
  #end

  ##def connect(target_layer) do

  ##end
end
