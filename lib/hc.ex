defmodule Hc do

  def strip_cycle do
    for i <- Enum.take_every(0..16711422, 1000), do: led_cycle(i)
  end

  def led_cycle(color) do
    for i <- 0..101 do
      %MySensors.Packet{ack: false, 
        child_sensor_id: i, 
        command: "command_set", 
        node_id: 3, 
        type: "value_rgb", 
        payload: color
      } |> MySensors.Gateway.write_packet()
      Process.sleep(50)
    end
  end
end
