defmodule HcWeb.MySensors.SensorTriggerController do
  use HcWeb, :controller

  # alias MySensors.Triggers
  # alias MySensors.SensorTrigger

  action_fallback(HcWeb.FallbackController)

  # def index(conn, %{"node_id" => node_id, "child_sensor_id" => child_sensor_id}) do
  #   sensor_values = Context.all_sensors_values(node_id, child_sensor_id)
  #   render(conn, "index.json", sensor_values: sensor_values)
  # end
end
