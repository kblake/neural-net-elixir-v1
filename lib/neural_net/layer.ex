defmodule NeuralNet.Layer do
  def start_link(layer_name, neurons \\ []) do
    Agent.start_link(fn -> neurons end, name: layer_name)
  end

  def init_neurons_by_size(size) do
    List.duplicate(%NeuralNet.Neuron{}, size)
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

  defp set_neurons(layer_name, neurons) do
    clear_neurons(layer_name)
    add_neurons(layer_name, neurons)
  end

  def activate(layer_name, values \\ nil) do
    Agent.update(layer_name, fn neurons ->
      neurons
      |> Stream.with_index
      |> Enum.map(fn(tuple) ->
        {neuron, index} = tuple
        NeuralNet.Neuron.activate(neuron, Enum.at(List.wrap(values), index))
      end)
    end)

    neurons(layer_name)
  end

  defp contains_bias?(layer_name) do
    Enum.any? neurons(layer_name), fn(output_neuron) ->
      output_neuron.bias?
    end
  end

  def connect(input_layer_name, output_layer_name) do
    Agent.start_link(fn -> [] end, name: :source_neurons)
    Agent.start_link(fn -> [] end, name: :target_neurons)

    unless contains_bias?(input_layer_name) do
      add_neurons(input_layer_name, [NeuralNet.Neuron.bias_neuron])
    end

    # TODO: refactor this
    # accumulate connections then map
    # Result: Output layer of source neurons
    Enum.each neurons(input_layer_name), fn(source) ->
      Enum.each neurons(output_layer_name), fn(target) ->
        {:ok, s, _} = NeuralNet.Neuron.connect(source, target)
        add_neurons(:source_neurons, [s])
      end
    end

    # TODO: refactor this
    # accumulate connections then map
    # Result: Input layer of target neurons
    Enum.each neurons(output_layer_name), fn(target) ->
      Enum.each neurons(input_layer_name), fn(source) ->
        {:ok, _, t} = NeuralNet.Neuron.connect(source, target)
        add_neurons(:target_neurons, [t])
      end
    end

    input_layer_neurons = build_input_layer_neurons_with_connections(input_layer_name, output_layer_name)
    output_layer_neurons = build_output_layer_neurons_with_connections(input_layer_name, output_layer_name)

    set_neurons(input_layer_name, input_layer_neurons)
    set_neurons(output_layer_name, output_layer_neurons)

    stop_agent(:source_neurons)
    stop_agent(:target_neurons)

    {:ok, input_layer_neurons, output_layer_neurons}
  end

  defp stop_agent(agent_name) do
    Process.exit(Process.whereis(agent_name), :shutdown)
  end


  # TODO: simplify this method
  defp build_input_layer_neurons_with_connections(input_layer_name, output_layer_name) do
    # group neurons by source
    input_layer_outgoing_connections =
    Enum.chunk(neurons(:source_neurons), length(neurons(output_layer_name)))
    |> Enum.map(fn(neurons) -> # collect the connections for each source neuron
      Enum.map neurons, fn neuron ->
        List.first neuron.outgoing # list of connections for a source neuron
      end
    end)

    # reduce each source neuron with collected outgoing connections
    neurons(input_layer_name)
    |> Stream.with_index
    |> Enum.map(fn tuple ->
      {neuron, index} = tuple
      %NeuralNet.Neuron{neuron | outgoing: Enum.at(input_layer_outgoing_connections, index)}
    end)
  end


  # TODO: simplify this method
  # TODO: consildate this method
  defp build_output_layer_neurons_with_connections(input_layer_name, output_layer_name) do
    # group neurons by source
    output_layer_incoming_connections =
    Enum.chunk(neurons(:target_neurons), length(neurons(input_layer_name)))
    |> Enum.map(fn(neurons) -> # collect the connections for each target neuron
      Enum.map neurons, fn neuron ->
        List.first neuron.incoming # list of connections for a target neuron
      end
    end)

    # reduce each source neuron with collected outgoing connections
    neurons(output_layer_name)
    |> Stream.with_index
    |> Enum.map(fn tuple ->
      {neuron, index} = tuple
      %NeuralNet.Neuron{neuron | incoming: Enum.at(output_layer_incoming_connections, index)}
    end)
  end
end
