defmodule Hc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    children = [
      {MySensors.Migrator, []},
      {MySensors.Transport, [MySensors.Transport.TCP, []]}
    ]
    opts = [strategy: :one_for_one, name: Hc.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
