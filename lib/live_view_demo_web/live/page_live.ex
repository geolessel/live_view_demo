defmodule LiveViewDemoWeb.PageLive do
  use Phoenix.LiveView
  require Logger

  def render(assigns) do
    Logger.debug("assigns: #{inspect(assigns)}")
    LiveViewDemoWeb.PageView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    {:ok, assign(socket, %{regex: nil, pattern: "", input: "", error: ""})}
  end

  def handle_event("form_update", %{"regex" => %{"pattern" => ""}}, socket),
    do: {:noreply, assign(socket, regex: nil)}

  def handle_event("form_update", %{"regex" => params}, socket) do
    pattern = Map.get(params, "pattern")
    input = Map.get(params, "input")

    case Regex.compile(pattern) do
      {:ok, regex} ->
        {:noreply, assign(socket, %{regex: regex, pattern: pattern, input: input, error: ""})}

      {:error, {error, _}} ->
        {:noreply, assign(socket, %{regex: nil, pattern: pattern, input: input, error: error})}
    end
  end
end
