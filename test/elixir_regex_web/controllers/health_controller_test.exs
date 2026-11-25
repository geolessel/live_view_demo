defmodule ElixirRegexWeb.HealthControllerTest do
  use ElixirRegexWeb.ConnCase, async: true

  test "GET /up responds 200 so kamal-proxy routes traffic to the container", %{conn: conn} do
    conn = get(conn, ~p"/up")

    assert response(conn, 200) == "ok"
    assert response_content_type(conn, :text) =~ "text/plain"
  end

  test "GET /up does not start a session", %{conn: conn} do
    conn = get(conn, ~p"/up")

    assert get_resp_header(conn, "set-cookie") == []
  end
end
