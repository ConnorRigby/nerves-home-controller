defmodule HcIRC.Supervisor do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args)
  end

  def init([]) do
    children = [
      %{id: :irc_client, start: {ExIrc.Client, :start_link, [[], [name: ExIrc.Client]]}},
      {HcIRC.Connection, [client: ExIrc.Client]}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
