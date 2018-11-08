defmodule HcWeb.MySensors.SensorValueView do
  use HcWeb, :view
  alias HcWeb.MySensors.SensorValueView
  alias NimbleCSV.RFC4180, as: CSV

  def render("index.json", %{sensor_values: sensor_values}) do
    %{data: render_many(sensor_values, SensorValueView, "sensor_value.json")}
  end

  def render("show.json", %{sensor_value: sensor_value}) do
    %{data: render_one(sensor_value, SensorValueView, "sensor_value.json")}
  end

  def render("sensor_value.json", %{sensor_value: sensor_value}) do
    %{
      inserted_at: sensor_value.inserted_at,
      type: sensor_value.type,
      value: sensor_value.value
    }
  end
end
