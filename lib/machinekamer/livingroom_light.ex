defmodule Machinekamer.LivingroomLight do
  use GenServer
  require Logger

  def start_link(args), do: GenServer.start_link(__MODULE__, args)

  def init(_args) do
    Phoenix.PubSub.subscribe(:mqtt, "zigbee2mqtt/light/living_room")

    Machinekamer.publish("zigbee2mqtt/light/living_room/get", %{"state" => ""})

    Logger.info("Living room light initialized")

    {:ok, %{}}
  end

  def handle_info(new_state, prev_state) do
    checks = [
      prev_state["state"] == "ON",
      new_state["state"] == "ON",
      prev_state["brightness"] > new_state["brightness"],
      new_state["brightness"] == 1
    ]

    if Enum.all?(checks) do
      Machinekamer.publish("zigbee2mqtt/light/living_room/set", %{"state" => "OFF"})
    end

    {:noreply, new_state}
  end
end
