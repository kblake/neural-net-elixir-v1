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

  def clear_neurons(layer_name) do
    Agent.update(layer_name, &(&1 -- &1))
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

    neurons(layer_name)
  end

  def connect(input_layer_name, output_layer_name) do
    Agent.start_link(fn -> [] end, name: :source_neurons)
    #Agent.start_link(fn -> [] end, name: :target_neurons)

    Enum.each NeuralNet.Layer.neurons(input_layer_name), fn(source) ->
      Enum.each NeuralNet.Layer.neurons(output_layer_name), fn(target) ->
        {:ok, s, t} = NeuralNet.Neuron.connect(source, target)
        add_neurons(:source_neurons, [s])
        #add_neurons(:target_neurons, [t])
      end
    end

    input_layer_neurons = build_input_layer_neurons_with_connections(input_layer_name, output_layer_name)
    clear_neurons(:input_layer)
    add_neurons(input_layer_name, input_layer_neurons)


    stop_agent(:source_neurons)

    {:ok, input_layer_neurons, []}
  end

  defp stop_agent(agent_name) do
    Process.exit(Process.whereis(agent_name), :shutdown)
  end

  defp build_input_layer_neurons_with_connections(input_layer_name, output_layer_name) do
    neurons_with_connections = Enum.chunk(neurons(:source_neurons), length(NeuralNet.Layer.neurons(output_layer_name)))

    input_layer_outgoing_connections = Enum.map neurons_with_connections, fn(neurons) ->
      Enum.map neurons, fn neuron ->
        List.first neuron.outgoing
      end
    end

    updated_input_neurons =
      NeuralNet.Layer.neurons(input_layer_name)
      |> Stream.with_index
      |> Enum.map(fn tuple ->
        {neuron, index} = tuple
        %NeuralNet.Neuron{neuron | outgoing: Enum.at(input_layer_outgoing_connections, index)}
      end)
  end
end
