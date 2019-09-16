defmodule LiveViewDemoWeb.PageLive do
  use Phoenix.LiveView
  require Logger

  def render(assigns) do
    Logger.debug("assigns: #{inspect(assigns)}")
    LiveViewDemoWeb.PageView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    {:ok, assign(socket, %{result: "", pattern: "", input: ""})}
  end

  def handle_event("form_update", %{"regex" => params}, socket) do
    pattern = Map.get(params, "pattern", "")
    input = Map.get(params, "input", "")

    {:ok, compiled} = Regex.compile(pattern)
    result = Regex.scan(compiled, input, return: :index)

    Logger.debug("GEO: result: #{inspect(result)}")

    {:noreply, assign(socket, %{result: result, pattern: pattern, input: input})}
  end
end
