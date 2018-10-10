defmodule Hc.MixProject do
  use Mix.Project

  @target System.get_env("MIX_TARGET") || "host"

  def project do
    [
      app: :hc,
      version: "0.1.0",
      elixir: "~> 1.6",
      target: @target,
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      archives: [nerves_bootstrap: "~> 1.0"],
      deps_path: "deps/#{@target}",
      build_path: "_build/#{@target}",
      lockfile: "mix.lock.#{@target}",
      start_permanent: Mix.env() == :prod,
      build_embedded: @target != "host",
      aliases: [loadconfig: [&bootstrap/1]],
      deps: deps()
    ] ++ my_sensors_mysgw_config(@target)
  end

  # Starting nerves_bootstrap adds the required aliases to Mix.Project.config()
  # Aliases are only added if MIX_TARGET is set.
  def bootstrap(args) do
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Hc.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nerves, "~> 1.3", runtime: false},
      {:shoehorn, "~> 0.4"},
      {:ring_logger, "~> 0.4"},
      {:my_sensors, path: "../my_sensors"},
      {:sqlite_ecto2, "~> 2.2"},
      {:nerves_uart, "~> 1.2"},
      {:phoenix, github: "phoenixframework/phoenix", override: true},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_html, "~> 2.11"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:cowboy, "~> 1.0"}
    ] ++ deps(@target)
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specify target specific dependencies
  defp deps("host"),
    do: [
      {:phoenix_live_reload, "~> 1.0", only: :dev}
    ]

  defp deps(target) do
    [
      {:nerves_runtime, "~> 0.6"},
      {:nerves_init_gadget, "~> 0.4"},
      {:my_sensors_mysgw, "~> 2.4.0-beta.3"}
    ] ++ system(target)
  end

  defp my_sensors_mysgw_config("host"), do: []

  defp my_sensors_mysgw_config("bbb"),
    do: [
      my_sensors_mysgw_spi_dev: "/dev/spidev1.0",
      my_sensors_mysgw_irq_pin: "47",
      my_sensors_mysgw_cs_pin: "5",
      my_sensors_mysgw_ce_pin: "65"
    ]

  defp system("bbb"), do: [{:nerves_system_bbb, "~> 2.0.0-rc.0", runtime: false}]
  defp system(target), do: Mix.raise("Unknown MIX_TARGET: #{target}")
end
