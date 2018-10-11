defmodule HcWeb.Router do
  use HcWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", HcWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  # Other scopes may use custom stacks.
  scope "/api", HcWeb do
    pipe_through(:api)
  end

  # Other scopes may use custom stacks.
  scope "/api/my_sensors", HcWeb.MySensors do
    pipe_through(:api)
    resources("/nodes", NodeController, only: [:index, :show])
    resources("/nodes/:node_id/sensors", SensorController, only: [:index, :show])

    get(
      "/nodes/:node_id/sensors/:child_sensor_id/sensor_values/latest",
      SensorValueController,
      :latest
    )
    
    get(
      "/nodes/:node_id/sensors/:child_sensor_id/:type/:value",
      SensorController,
      :dispatch_packet
    )

    resources("/nodes/:node_id/sensors/:child_sensor_id/sensor_values", SensorValueController,
      only: [:index]
    )



    resources("/nodes/:node_id/sensors/:child_sensor_id/sensor_triggers", SensorTriggerController)
  end
end
