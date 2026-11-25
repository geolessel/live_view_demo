defmodule ElixirRegexWeb.Router do
  use ElixirRegexWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ElixirRegexWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # kamal-proxy polls this before it sends traffic to a new container. It
  # skips the browser pipeline so health checks do not create sessions.
  scope "/", ElixirRegexWeb do
    get "/up", HealthController, :show
  end

  scope "/", ElixirRegexWeb do
    pipe_through :browser

    live "/", PageLive
    live "/about", AboutLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", ElixirRegexWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:elixir_regex, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ElixirRegexWeb.Telemetry
    end
  end
end
