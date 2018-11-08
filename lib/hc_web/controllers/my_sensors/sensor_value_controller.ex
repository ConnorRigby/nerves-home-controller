defmodule HcWeb.MySensors.SensorValueController do
  use HcWeb, :controller
  alias MySensors.Context
  alias NimbleCSV.RFC4180, as: CSV
  action_fallback(HcWeb.FallbackController)

  def index(conn, %{"node_id" => node_id, "child_sensor_id" => child_sensor_id}) do
    sensor_values = Context.all_sensor_values(node_id, child_sensor_id)
    render(conn, "index.json", sensor_values: sensor_values)
  end

  def latest(conn, %{"node_id" => node_id, "child_sensor_id" => child_sensor_id}) do
    sensor_value = Context.latest_sensor_value(node_id, child_sensor_id)
    render(conn, "show.json", sensor_value: sensor_value)
  end

  def export(conn, %{"node_id" => node_id, "child_sensor_id" => child_sensor_id}) do
    sensor_values = Context.all_sensor_values(node_id, child_sensor_id)

    csv_content =
      ([["id", "sensor_id", "type", "value", "inserted_at"]] ++
         Enum.map(sensor_values, fn sv ->
           local = Timex.local(sv.inserted_at)
           [sv.id, sv.sensor_id, sv.type, sv.value, to_string(local)]
         end))
      |> CSV.dump_to_iodata()

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"sensor_values.csv\"")
    |> send_resp(200, csv_content)
  end
end
