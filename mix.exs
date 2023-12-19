defmodule Machinekamer.MixProject do
  use Mix.Project

  def project do
    [
      app: :machinekamer,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Machinekamer.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:emqtt, github: "emqx/emqtt", tag: "1.10.1", system_env: [{"BUILD_WITHOUT_QUIC", "1"}]},
      {:jason, "~> 1.4"},
      {:phoenix_pubsub, "~> 2.1"},
      {:tz, "~> 0.26.5"},
      {:solarex, "~> 0.1.2"},
      {:timex, "~> 3.7"}
    ]
  end
end
