defmodule LiveViewDemoWeb.AboutLive do
  use Phoenix.LiveView

  def render(assigns) do
    LiveViewDemoWeb.AboutView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    {:ok, socket}
  end
end
