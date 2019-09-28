defmodule LiveViewDemoWeb.PageLive do
  use Phoenix.LiveView
  require Logger

  def render(assigns) do
    LiveViewDemoWeb.PageView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    {:ok,
     assign(socket, %{
       compiled: nil,
       pattern: "",
       input: "",
       error: "",
       options: []
     })}
  end

  def handle_event("form_update", %{"regex" => %{"pattern" => ""}}, socket),
    do: {:noreply, assign(socket, compiled: nil)}

  def handle_event("form_update", %{"regex" => params}, socket) do
    pattern = Map.get(params, "pattern")
    input = Map.get(params, "input")
    options = Map.get(params, "options", [])
    Logger.info(inspect(params))
    Logger.info(inspect(options, label: "options"))
    Logger.info(Enum.member?(options, "f"))

    case Regex.compile(pattern, Enum.join(options)) do
      {:ok, compiled} ->
        {:noreply,
         assign(socket, %{
           compiled: compiled,
           pattern: pattern,
           options: options,
           input: input,
           error: ""
         })}

      {:error, {error, _}} ->
        {:noreply,
         assign(socket, %{
           compiled: nil,
           pattern: pattern,
           options: options,
           input: input,
           error: error
         })}
    end
  end
end
