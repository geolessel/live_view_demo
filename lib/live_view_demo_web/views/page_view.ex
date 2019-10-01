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
          content_tag(:span, ch)

        ch == "\n" ->
          tag(:br)

        true ->
          ch
      end
    end)
  end

  def regex_call(input, regex, options) do
    content_tag :p do
      content_tag(:pre, "Regex.scan(~r/#{regex}/#{options}, \"#{input}\")")
    end
  end

  def matches(input, regex) do
    regex
    |> Regex.scan(input)
    |> List.flatten()
    |> Enum.with_index()
    |> Enum.map(fn {match, i} ->
      "[#{i}]: #{match}<br />"
      |> raw()
    end)
  end

  def named_captures(input, regex) do
    regex
    |> Regex.named_captures(input)
    |> case do
      nil ->
        []

      key ->
        key
        |> Enum.map(fn {k, v} ->
          content_tag(:p, "#{k} => #{v}")
        end)
    end
    |> Enum.to_list()
  end
end
