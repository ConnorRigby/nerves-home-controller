defmodule HcWeb.MySensors.SensorTriggerView do
  use HcWeb, :view
  alias HcWeb.MySensors.SensorTriggerView

  def render("index.json", %{sensor_triggers: sensor_triggers}) do
    %{data: render_many(sensor_triggers, SensorTriggerView, "sensor_trigger.json")}
  end

  def render("show.json", %{sensor_trigger: sensor_trigger}) do
    %{data: render_one(sensor_trigger, SensorTriggerView, "sensor_trigger.json")}
  end

  def render("sensor_trigger.json", %{sensor_trigger: sensor_trigger}) do
    %{id: sensor_trigger.id}
  end
end
