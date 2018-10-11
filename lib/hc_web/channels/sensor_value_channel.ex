defmodule HcWeb.SensorValueChannel do
  use Phoenix.Channel
  alias MySensors.{Broadcast, SensorValue}

  def join("sensor_values:" <> sensor_id , _params, socket) do
    send self(), :after_join
    {:ok, assign(socket, :sensor_id, String.to_integer(sensor_id))}
  end

  def handle_info(:after_join, socket) do
    IO.puts "subscribing: #{inspect self()} #{socket.assigns.sensor_id}"
    :ok = Broadcast.subscribe()
    {:noreply, socket}
  end

  def handle_info({:my_sensors, {:insert_or_update, %SensorValue{sensor_id: sid} = sv}}, %{assigns: %{sensor_id: sid}} = socket) do
    IO.puts "got matching sv: #{sid}"
    payload = HcWeb.MySensors.SensorValueView.render("sensor_value.json", %{sensor_value: sv})
    push socket, "sensor_value", payload
    {:noreply, socket}
  end
  
  def handle_info(_, socket) do
    {:noreply, socket}
  end

  def terminate(_, socket) do
    IO.inspect(socket, label: "terminate")
  end
end