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
    case payload do
      %{"occupancy" => true} -> toggle(:on)
      %{"occupancy" => false} -> toggle(:off)
    end

    {:noreply, state}
  end

  def toggle(:off) do
    Machinekamer.publish(
      "zigbee2mqtt/light_hallway/set",
      %{"state" => "OFF"}
    )
  end

  def toggle(:on) do
    now = DateTime.now!("Europe/Amsterdam")

    case now.hour do
      hour when hour < 8 or hour >= 17 ->
        Machinekamer.publish("zigbee2mqtt/light_hallway/set", %{"state" => "ON"})

      _ ->
        :ignored
    end
  end
end
