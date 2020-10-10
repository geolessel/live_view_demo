defmodule LiveViewDemoWeb.PageLive do
  use LiveViewDemoWeb, :live_view

  def render(assigns) do
    LiveViewDemoWeb.PageView.render("index.html", assigns)
  end

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket, %{
       compiled: nil,
       pattern: "",
       input: "",
       error: "",
       modifiers: []
     })}
  end

  def handle_params(params, _url, socket) when map_size(params) == 0 do
    {:noreply, assign(socket, compiled: nil)}
  end

  def handle_params(params, _url, socket) do
    input = Map.get(params, "input", "")
    pattern = Map.get(params, "pattern", "")
    modifiers = Map.get(params, "modifiers", "") |> String.split("")

    case Regex.compile(pattern, Enum.join(modifiers)) do
      {:ok, compiled} ->
        {:noreply,
         assign(socket, %{
           compiled: compiled,
           pattern: pattern,
           modifiers: modifiers,
           input: input,
           error: ""
         })}

      {:error, {error, _}} ->
        {:noreply,
         assign(socket, %{
           compiled: nil,
           pattern: pattern,
           modifiers: modifiers,
           input: input,
           error: error
         })}
    end
  end

  def handle_event("form_update", %{"regex" => %{"pattern" => ""}}, socket),
    do: {:noreply, push_patch(assign(socket, compiled: nil), to: "/")}

  def handle_event("form_update", %{"regex" => params}, socket) do
    query =
      ["pattern", "input", "modifiers"]
      |> Enum.reduce(%{}, fn str, acc ->
        case Map.get(params, str) do
          nil -> acc
          list when is_list(list) -> Map.put(acc, str, Enum.join(list))
          "" -> acc
          val -> Map.put(acc, str, val)
        end
      end)
      |> Enum.reverse()
      |> URI.encode_query()

    case String.length(query) do
      0 ->
        {:noreply, push_patch(socket, to: "/")}

      _ ->
        {:noreply, push_patch(socket, to: "/?#{query}")}
    end
  end
end
