defmodule Machinekamer.Sensor.FusedMotion do
  use GenServer
  require Logger

  def start_link(args), do: GenServer.start_link(__MODULE__, args)

  def init(_args) do
    Phoenix.PubSub.subscribe(:mqtt, "zigbee2mqtt/sensor/motion/hallway")
    Phoenix.PubSub.subscribe(:mqtt, "zigbee2mqtt/sensor/motion/bathroom")

    Logger.info("Fused motion sensor initialized")

    init_state = %{
      "sensor/motion/bathroom" => false,
      "sensor/motion/hallway" => false
    }

    {:ok, init_state}
  end

  def handle_info(message, state) do
    state
    |> update_state(message)
    |> publish_state()
    |> noreply()
  end

  def update_state(state, %{"device" => %{"friendlyName" => name}, "occupancy" => occupancy}) do
    %{state | name => occupancy}
  end

  def publish_state(state) do
    msg =
      case state do
        %{
          "sensor/motion/bathroom" => false,
          "sensor/motion/hallway" => false
        } ->
          %{occupancy: false}

        _ ->
          %{occupancy: true}
      end

    Machinekamer.publish("machinekamer/sensor/motion/upstairs-fused", msg)
    state
  end

  def noreply(state), do: {:noreply, state}
end
