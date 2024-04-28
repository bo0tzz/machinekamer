defmodule Machinekamer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Phoenix.PubSub, name: :mqtt},
      Machinekamer.MqttConnection,
      Machinekamer.Sensor.FusedMotion,
      Machinekamer.HallwayLight,
      Machinekamer.LivingroomLight
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Machinekamer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
