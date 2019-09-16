defmodule LiveViewDemoWeb.PageLive do
  use Phoenix.LiveView
  require Logger

  def render(assigns) do
    Logger.debug("assigns: #{inspect(assigns)}")
    LiveViewDemoWeb.PageView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    {:ok, assign(socket, %{result: [], pattern: "", input: "", error: ""})}
  end

  def handle_event("form_update", %{"regex" => %{"pattern" => ""}}, socket),
    do: {:noreply, socket}

  def handle_event("form_update", %{"regex" => params}, socket) do
    pattern = Map.get(params, "pattern")
    input = Map.get(params, "input")

    case Regex.compile(pattern) do
      {:ok, compiled} ->
        result = Regex.scan(compiled, input, return: :index)
        {:noreply, assign(socket, %{result: result, pattern: pattern, input: input, error: ""})}

      {:error, {error, _}} ->
        {:noreply, assign(socket, %{result: [], pattern: pattern, input: input, error: error})}
    end
  end
end
