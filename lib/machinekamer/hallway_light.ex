defmodule Machinekamer.HallwayLight do
  use GenServer
  require Logger
  alias Machinekamer.Clock

  def start_link(args), do: GenServer.start_link(__MODULE__, args)

  def init(_args) do
    Phoenix.PubSub.subscribe(:mqtt, "zigbee2mqtt/motion_hallway")

    Logger.info("Hallway light initialized")

    {:ok, %{}}
  end

  def handle_info(payload, state) do
    message =
      case payload do
        %{"occupancy" => true} -> %{"state" => "ON", "brightness" => brightness()}
        %{"occupancy" => false} -> %{"state" => "OFF"}
      end

    Machinekamer.publish("zigbee2mqtt/light_hallway/set", message)

    {:noreply, state}
  end

  defp brightness() do
    cond do
      # It's daytime, don't turn on the light
      Clock.is_light?() ->
        0

      # Everyone's asleep
      Clock.is_night?() ->
        1

      # People are still awake, but it's already dark
      Clock.is_evening?() ->
        Clock.minutes_to_bedtime()

      # People are waking up, but it's still dark
      Clock.is_morning?() ->
        Clock.minutes_after_waketime()

      true ->
        Logger.warning("Could not calculate brightness")
        0
    end
    # No less than 0
    |> max(0)
    # No more than 254
    |> min(254)
  end
end
