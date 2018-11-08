defmodule HcIRC.Connection do
  use GenServer
  require Logger
  alias MySensors.{Broadcast, SensorValue}

  @host Application.get_env(:hc, __MODULE__)[:host]
  @port Application.get_env(:hc, __MODULE__)[:port]
  @pass Application.get_env(:hc, __MODULE__)[:pass]
  @name Application.get_env(:hc, __MODULE__)[:name]
  @channel Application.get_env(:hc, __MODULE__)[:channel]
  @nick Application.get_env(:hc, __MODULE__)[:nick]
  @user Application.get_env(:hc, __MODULE__)[:user]

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(args) do
    client = Keyword.fetch!(args, :client)
    ExIrc.Client.add_handler(client, self())
    ExIrc.Client.connect!(client, @host, @port)
    {:ok, %{client: client}}
  end

  def handle_info({:connected, server, port}, state) do
    Logger.info("Connected to #{server}:#{port}")
    ExIrc.Client.logon(state.client, @pass, @nick, @user, @name)
    {:noreply, state}
  end

  def handle_info(:logged_in, state) do
    Logger.info("Logged in to server")
    ExIrc.Client.join(state.client, @channel)
    :ok = Broadcast.subscribe()
    {:noreply, state}
  end

  def handle_info({:unrecognized, _}, state) do
    {:noreply, state}
  end

  def handle_info({:my_sensors, {:insert_or_update, %SensorValue{} = sv}}, state) do
    # Logger.info "irc sensor value: #{inspect(sv)}"
    payload = HcWeb.MySensors.SensorValueView.render("sensor_value.json", %{sensor_value: sv})
    :ok = ExIrc.Client.msg(state.client, :privmsg, @channel, Jason.encode!(payload))
    {:noreply, state}
  end

  def handle_info({:my_sensors, _}, state) do
    {:noreply, state}
  end

  def handle_info(msg, state) do
    Logger.error("Received unknown IRC messsage: #{inspect(msg)}")
    {:noreply, state}
  end
end
