defmodule ElixirRegexWeb.PageLiveTest do
  use ElixirRegexWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "renders an empty form with no results", %{conn: conn} do
    {:ok, view, html} = live(conn, ~p"/")

    assert html =~ "Elixir Regex"
    refute has_element?(view, "section.results")
  end

  test "renders results from the URL so links can be shared", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/?#{[pattern: "b+", input: "abbc", modifiers: "i"]}")

    assert has_element?(view, "input[name='regex[pattern]'][value='b+']")
    assert has_element?(view, "#case[checked]")
    refute has_element?(view, "#unicode[checked]")
    assert render(view) =~ "Regex.scan(~r/b+/i, &quot;abbc&quot;)"
    assert has_element?(view, "#matches", "[0]: bb")
  end

  test "updates the URL when the form changes", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/")

    view
    |> element("form")
    |> render_change(%{regex: %{pattern: "a", input: "cat", modifiers: ["i", "u"]}})

    assert_patch(view, ~p"/?#{[input: "cat", modifiers: "iu", pattern: "a"]}")
    assert has_element?(view, "#matches", "[0]: a")
  end

  test "clearing the pattern resets the URL", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/?#{[pattern: "a", input: "cat"]}")

    view |> element("form") |> render_change(%{regex: %{pattern: "", input: "cat"}})

    assert_patch(view, ~p"/")
    refute has_element?(view, "section.results")
  end

  test "shows the compile error for an invalid pattern", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/?#{[pattern: "(a", input: "a"]}")

    assert has_element?(view, ".alert", "missing closing parenthesis")
    refute has_element?(view, "section.results")
  end

  test "shows an error for an unknown modifier", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/?#{[pattern: "a", modifiers: "z"]}")

    assert has_element?(view, ".alert", "invalid modifier: z")
  end

  test "lists named captures", %{conn: conn} do
    {:ok, view, _html} =
      live(conn, ~p"/?#{[pattern: "(?<year>\\d{4})", input: "in 2019"]}")

    assert has_element?(view, "#named-captures", "year => 2019")
  end

  test "does not crash with named captures and no match", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/?#{[pattern: "(?<year>\\d{4})", input: "none"]}")

    refute has_element?(view, "#named-captures p")
  end

  test "escapes user input in every result section", %{conn: conn} do
    payload = "<img src=x onerror=alert(1)>"
    {:ok, view, _html} = live(conn, ~p"/?#{[pattern: ".+", input: payload]}")

    html = render(view)
    refute html =~ "<img"
    assert html =~ "&lt;img"
  end

  describe "highlighted text" do
    test "highlights only the matched graphemes for multibyte input", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/?#{[pattern: "é", input: "aéb", modifiers: "u"]}")

      assert has_element?(view, "#highlighted span", "é")
      refute has_element?(view, "#highlighted span", "b")
    end

    test "adds no whitespace between graphemes", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/?#{[pattern: "b", input: "ab c"]}")

      text =
        view |> element("#highlighted") |> render() |> LazyHTML.from_fragment() |> LazyHTML.text()

      assert text == "ab c"
    end

    test "zero-length matches highlight nothing", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/?#{[pattern: "x*", input: "ab"]}")

      refute has_element?(view, "#highlighted span")
    end

    test "renders newlines as line breaks", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/?#{[pattern: "b", input: "a\nb"]}")

      assert has_element?(view, "#highlighted br")
    end
  end

  test "links to the About page", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/")

    assert {:ok, _about, html} =
             view |> element("footer a", "About") |> render_click() |> follow_redirect(conn)

    assert html =~ "Phoenix Phrenzy"
  end
end
