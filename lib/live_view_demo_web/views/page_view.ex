defmodule LiveViewDemoWeb.PageView do
  use LiveViewDemoWeb, :view

  def full_results(input, regex) do
    regex_result = Regex.scan(regex, input, return: :index)

    input
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {ch, i} ->
      cond do
        Enum.find(List.flatten(regex_result), fn {idx, length} ->
          Enum.member?(idx..(idx + length - 1), i)
        end) ->
          content_tag(:span, ch, style: "color: green; text-decoration: underline;")

        ch == "\n" ->
          tag(:br)

        true ->
          ch
      end
    end)
  end

  def matches(input, regex) do
    regex
    |> Regex.scan(input)
    |> List.flatten()
    |> Enum.with_index()
    |> Enum.map(fn {match, i} ->
      content_tag(:div, "[#{i}]: #{match}")
    end)
  end

  def named_captures(input, regex) do
    regex
    |> Regex.named_captures(input)
    |> Enum.to_list()
    |> Enum.map(fn {k, v} ->
      content_tag(:div, "#{k} => #{v}")
    end)
  end
end
