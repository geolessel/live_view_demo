defmodule ElixirRegexWeb.HealthController do
  use ElixirRegexWeb, :controller

  def show(conn, _params) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "ok")
  end
end
