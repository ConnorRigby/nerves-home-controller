defmodule HcWeb.MySensors.NodeView do
  use HcWeb, :view
  alias HcWeb.MySensors.NodeView

  def render("index.json", %{nodes: nodes}) do
    %{data: render_many(nodes, NodeView, "node.json")}
  end

  def render("show.json", %{node: node}) do
    %{data: render_one(node, NodeView, "node.json")}
  end

  def render("node.json", %{node: node}) do
    %{
      battery_level: node.battery_level,
      config: node.config,
      id: node.id,
      name: node.name,
      protocol: node.protocol,
      sketch_name: node.sketch_name,
      sketch_version: node.sketch_version,
      status: node.status
    }
  end
end
