defmodule LiveViewDemoWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :live_view_demo

  @session_options [
    store: :cookie,
    key: "_elixir_regex_key",
    signing_salt: "lluvoo38lvloa8dh3o80387vyasdo74"
  ]

  socket "/socket", LiveViewDemoWeb.UserSocket,
    websocket: true,
    longpoll: false

  socket "/live", Phoenix.LiveView.Socket,
    websocket: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :live_view_demo,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session, @session_options

  plug LiveViewDemoWeb.Router

  def init(:supervisor, config) do
    {:ok,
     Keyword.merge(config,
       url: [
         host: System.get_env("VIRTUAL_HOST", "www.elixirregex.com"),
         port: 443,
         scheme: "https"
       ]
     )}
  end
end
