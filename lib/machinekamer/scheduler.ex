defmodule Machinekamer.Scheduler do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    plan()
    {:ok, %{}}
  end

  def plan do
    GenServer.cast(__MODULE__, :plan)
  end

  @impl true
  def handle_cast(:plan, state) do
    sunset = Machinekamer.Clock.sunset_today()
    Logger.info("Planning sunset handler for #{sunset}")
    SchedEx.run_at(&run_sunset/0, sunset) |> IO.inspect()
    {:noreply, state}
  end

  defp run_sunset do
    Logger.info("Running sunset handler")
    Machinekamer.LivingroomLight.turn_on()
    Machinekamer.publish("zigbee2mqtt/light/server_rack/get", %{"state" => "ON"})
  end
end
