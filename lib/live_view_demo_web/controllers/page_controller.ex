defmodule LiveViewDemoWeb.PageController do
  use LiveViewDemoWeb, :controller

  def index(conn, _params) do
    Phoenix.LiveView.Controller.live_render(conn, LiveViewDemoWeb.PageLive, session: %{})
  end
end
