defmodule Hc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  case Mix.Project.config()[:target] do
    "host" ->
      @transport_config [
        host: to_charlist(Application.get_all_env(:nerves_init_gadget)[:mdns_domain])
      ]

    _ ->
      @transport_config []
  end

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    children = [
      {MySensors.Transport, [MySensors.Transport.TCP, @transport_config]},
      HcWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Hc.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    HcWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
