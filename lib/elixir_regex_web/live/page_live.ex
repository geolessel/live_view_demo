defmodule ElixirRegexWeb.PageLive do
  use ElixirRegexWeb, :live_view

  @modifiers [
    {"unicode", "u", "Unicode"},
    {"case", "i", "Case insensitive"},
    {"dotmatch", "s", "Dot matches newlines"},
    {"multiline", "m", "Multiline"},
    {"extended", "x", "Extended"},
    {"firstline", "f", "Firstline"},
    {"ungreedy", "U", "Ungreedy"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       all_modifiers: @modifiers,
       compiled: nil,
       pattern: "",
       input: "",
       error: "",
       modifiers: []
     )}
  end

  @impl true
  def handle_params(params, _url, socket) when map_size(params) == 0 do
    {:noreply, assign(socket, compiled: nil, error: "")}
  end

  def handle_params(params, _url, socket) do
    pattern = Map.get(params, "pattern", "")
    modifiers = params |> Map.get("modifiers", "") |> String.graphemes()

    socket =
      assign(socket, pattern: pattern, input: Map.get(params, "input", ""), modifiers: modifiers)

    case Regex.compile(pattern, Enum.join(modifiers)) do
      {:ok, compiled} ->
        {:noreply, assign(socket, compiled: compiled, error: "")}

      {:error, {:invalid_option, option}} ->
        {:noreply, assign(socket, compiled: nil, error: "invalid modifier: #{option}")}

      {:error, {reason, _position}} ->
        {:noreply, assign(socket, compiled: nil, error: to_string(reason))}
    end
  end

  @impl true
  def handle_event("form_update", %{"regex" => %{"pattern" => ""}}, socket) do
    {:noreply, push_patch(assign(socket, compiled: nil, error: ""), to: ~p"/")}
  end

  def handle_event("form_update", %{"regex" => params}, socket) do
    query =
      for key <- ["pattern", "input", "modifiers"],
          value = params |> Map.get(key) |> query_value(),
          value != "",
          into: %{},
          do: {key, value}

    {:noreply, push_patch(socket, to: ~p"/?#{query}")}
  end

  defp query_value(list) when is_list(list), do: Enum.join(list)
  defp query_value(value), do: value || ""

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app>
      <:nav><.link navigate={~p"/about"}>About</.link></:nav>

      <form id="regex-form" phx-change="form_update" phx-submit="form_update">
        <header>
          <h1>Elixir Regex</h1>
        </header>

        <section class="form">
          <div class="form-group">
            <label for="regex_pattern">Regex Pattern:</label>
            <div style="display:flex; align-items: center;">
              <code style="margin-right: 0.5em;">~r/</code>
              <input type="text" id="regex_pattern" name="regex[pattern]" value={@pattern} />
              <code style="margin-left: 0.5em;">/</code>
            </div>
          </div>

          <div class="form-group">
            <label>Modifiers:</label>
            <div class="d-f mb-1" style="flex-direction: row; flex-wrap: wrap;">
              <div :for={{id, flag, label} <- @all_modifiers} class="mr-1 d-ib checkbox-wrap">
                <input
                  type="checkbox"
                  id={id}
                  name="regex[modifiers][]"
                  value={flag}
                  checked={flag in @modifiers}
                  class="checkbox checkbox-sm"
                />
                <label for={id}>{label} ({flag})</label>
              </div>
            </div>
          </div>

          <div class="form-group">
            <label for="regex_input">Input:</label>
            <textarea id="regex_input" name="regex[input]">{Phoenix.HTML.Form.normalize_value("textarea", @input)}</textarea>
          </div>
        </section>

        <div class="alert">{@error}</div>

        <section :if={@compiled} class="results mt-1">
          <h2>Function Call</h2>
          <div class="mb-2" style="overflow: scroll;">
            <pre>Regex.scan(~r/{@pattern}/{@modifiers}, "{@input}")</pre>
          </div>

          <h2>Results</h2>
          <div class="results-display">
            <h3>Text:</h3>
            <.highlighted input={@input} regex={@compiled} />

            <h3>Matches:</h3>
            <p id="matches">
              <%= for {match, i} <- matches(@input, @compiled) do %>
                [{i}]: {match}<br />
              <% end %>
            </p>

            <%= if Regex.names(@compiled) != [] do %>
              <h3>Named Captures:</h3>
              <div id="named-captures">
                <p :for={{name, value} <- Regex.named_captures(@compiled, @input) || []}>
                  {name} => {value}
                </p>
              </div>
            <% end %>
          </div>
        </section>
      </form>
    </Layouts.app>
    """
  end

  attr :input, :string, required: true
  attr :regex, Regex, required: true

  # Regex.scan/3 reports byte offsets, so the input is walked by grapheme while
  # a byte cursor is tracked; comparing match offsets to grapheme indexes
  # misplaces highlights after any multibyte character.
  defp highlighted(assigns) do
    matched_bytes =
      for [_ | _] = groups <- Regex.scan(assigns.regex, assigns.input, return: :index),
          {start, length} <- groups,
          byte <- start..(start + length - 1)//1,
          into: MapSet.new(),
          do: byte

    {segments, _offset} =
      assigns.input
      |> String.graphemes()
      |> Enum.map_reduce(0, fn grapheme, offset ->
        kind =
          cond do
            offset in matched_bytes -> :match
            grapheme == "\n" -> :newline
            true -> :text
          end

        {{kind, grapheme}, offset + byte_size(grapheme)}
      end)

    assigns = assign(assigns, :segments, segments)

    # Whitespace between segments would render as visible gaps in the text.
    ~H"""
    <p id="highlighted" phx-no-format><%= for {kind, grapheme} <- @segments do %><%= case kind do %><% :match -> %><span>{grapheme}</span><% :newline -> %><br /><% :text -> %>{grapheme}<% end %><% end %></p>
    """
  end

  defp matches(input, regex) do
    regex |> Regex.scan(input) |> List.flatten() |> Enum.with_index()
  end
end
