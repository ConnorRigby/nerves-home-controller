defmodule HcWeb.MySensors.NodeController do
  use HcWeb, :controller

  alias MySensors.Context
  alias MySensors.Node

  action_fallback(HcWeb.FallbackController)

  def index(conn, _params) do
    nodes = Context.all_nodes()
    render(conn, "index.json", nodes: nodes)
  end

  def show(conn, %{"id" => id}) do
    %Node{} = node = Context.get_node(id)
    render(conn, "show.json", node: node)
  end
end
