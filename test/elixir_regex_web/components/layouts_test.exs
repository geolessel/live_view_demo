defmodule ElixirRegexWeb.LayoutsTest do
  use ElixirRegexWeb.ConnCase, async: true

  test "the root layout loads Plausible and no Google Analytics", %{conn: conn} do
    html = conn |> get(~p"/") |> html_response(200)

    assert html =~ ~s(src="https://plausible.io/js/pa-KpRLkkNg03uYJuV5qa8Yr.js")
    assert html =~ "plausible.init()"
    refute html =~ "googletagmanager"
  end
end
