import Config

config :machinekamer,
  mqtt: [
    host: System.fetch_env!("MQTT_SERVER"),
    port: 1883,
    username: System.fetch_env!("MQTT_USER"),
    password: System.fetch_env!("MQTT_PASSWORD")
  ]
