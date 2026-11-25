defmodule ElixirRegexWeb.AboutLiveTest do
  use ElixirRegexWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "renders the About page with a link back home", %{conn: conn} do
    {:ok, view, html} = live(conn, ~p"/about")

    assert html =~ "About"

    assert {:ok, _home, _html} =
             view |> element("footer a", "Home") |> render_click() |> follow_redirect(conn)
  end
end
