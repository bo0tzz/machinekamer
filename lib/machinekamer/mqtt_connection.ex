defmodule Machinekamer.MqttConnection do
  use GenServer
  require Logger

  def start_link(args), do: GenServer.start_link(__MODULE__, args, name: __MODULE__)

  def init(_args) do
    opts =
      Application.fetch_env!(:machinekamer, :mqtt)
      |> Keyword.put(:proto_ver, :v5)

    {:ok, pid} = :emqtt.start_link(opts)
    {:ok, _props} = :emqtt.connect(pid)

    Logger.info("Mqtt connected")

    topic = "zigbee2mqtt/#"
    {:ok, _props, _reason} = :emqtt.subscribe(pid, %{}, [{topic, []}])

    Logger.info("Mqtt subscribed to #{topic}")

    state = %{pid: pid}

    {:ok, state}
  end

  def handle_info({:publish, %{topic: topic, payload: payload}}, state) do
    message = Jason.decode!(payload)

    Phoenix.PubSub.broadcast!(:mqtt, topic, message)

    {:noreply, state}
  end

  def handle_call({:publish, topic, message}, _from, state) do
    res = publish(state.pid, topic, message)

    {:reply, res, state}
  end

  defp publish(pid, topic, message) do
    payload = Jason.encode!(message)

    case :emqtt.publish(pid, topic, payload) do
      :ok -> :ok
      {:ok, _} -> :ok
      error -> raise "Publish error: #{inspect(error)}"
    end
  end

  def publish(topic, message) do
    GenServer.call(__MODULE__, {:publish, topic, message})
  end
end
