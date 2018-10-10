defmodule HcWeb.MySensors.SensorValueController do
  use HcWeb, :controller

  alias MySensors.Context

  action_fallback(HcWeb.FallbackController)

  def index(conn, %{"node_id" => node_id, "child_sensor_id" => child_sensor_id}) do
    sensor_values = Context.all_sensor_values(node_id, child_sensor_id)
    render(conn, "index.json", sensor_values: sensor_values)
  end

  def latest(conn, %{"node_id" => node_id, "child_sensor_id" => child_sensor_id}) do
    sensor_value = Context.latest_sensor_value(node_id, child_sensor_id)
    render(conn, "show.json", sensor_value: sensor_value)
  end
end
