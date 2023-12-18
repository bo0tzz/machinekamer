defmodule Machinekamer.HallwayLight do
  use GenServer
  require Logger

  def start_link(args), do: GenServer.start_link(__MODULE__, args)

  def init(_args) do
    Phoenix.PubSub.subscribe(:mqtt, "zigbee2mqtt/motion_hallway")

    Logger.info("Hallway light initialized")

    {:ok, %{}}
  end

  def handle_info(payload, state) do
    target_state =
      case payload do
        %{"occupancy" => true} -> %{"state" => "ON"}
        %{"occupancy" => false} -> %{"state" => "OFF"}
      end

    Machinekamer.publish("zigbee2mqtt/light_hallway/set", target_state)

    {:noreply, state}
  end
end
