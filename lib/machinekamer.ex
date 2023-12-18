defmodule Machinekamer do
  defdelegate publish(topic, message), to: Machinekamer.MqttConnection
end
