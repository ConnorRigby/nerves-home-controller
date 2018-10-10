defmodule HcWeb.MySensors.SensorView do
  use HcWeb, :view
  alias HcWeb.MySensors.SensorView

  def render("index.json", %{sensors: sensors}) do
    %{data: render_many(sensors, SensorView, "sensor.json")}
  end

  def render("show.json", %{sensor: sensor}) do
    %{data: render_one(sensor, SensorView, "sensor.json")}
  end

  def render("sensor.json", %{sensor: sensor}) do
    %{
      child_sensor_id: sensor.child_sensor_id,
      node_id: sensor.node_id,
      type: sensor.type
    }
  end

  def render("packet.json", %{packet: packet, raw: raw}) do
    %{
      data: %{
        ack: packet.ack,
        child_sensor_id: packet.child_sensor_id,
        command: to_string(packet.command),
        node_id: packet.node_id,
        payload: packet.payload,
        type: to_string(packet.type),
        raw: raw
      }
    }
  end
end
