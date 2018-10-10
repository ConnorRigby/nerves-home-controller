defmodule HcWeb.MySensors.SensorController do
  use HcWeb, :controller

  alias MySensors.{Context, Packet, Sensor}
  use Packet.Constants

  action_fallback(HcWeb.FallbackController)

  def index(conn, %{"node_id" => node_id}) do
    sensors = Context.all_sensors(node_id)
    render(conn, "index.json", sensors: sensors)
  end

  def show(conn, %{"node_id" => node_id, "id" => child_sensor_id}) do
    %Sensor{} = sensor = Context.get_sensor(node_id, child_sensor_id)
    render(conn, "show.json", sensor: sensor)
  end

  def dispatch_packet(conn, %{
        "node_id" => node_id,
        "child_sensor_id" => child_sensor_id,
        "type" => type,
        "value" => value
      }) do
    pkt = %Packet{
      ack: @ack_FALSE,
      child_sensor_id: child_sensor_id,
      command: @command_SET,
      node_id: node_id,
      payload: value,
      type: type
    }

    with {:ok, raw} <- Packet.encode(pkt),
         :ok <- MySensors.Gateway.write_packet(pkt) do
      render(conn, "packet.json", packet: pkt, raw: raw)
    else
      {:error, @value_UNKNOWN} ->
        conn |> put_status(400) |> json(%{error: "bad type: #{type}"})

      {:error, reason} ->
        conn |> put_status(400) |> json(%{error: "unknown error: #{inspect(reason)}"})
    end
  end
end
