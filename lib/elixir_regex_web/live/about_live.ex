defmodule ElixirRegexWeb.AboutLive do
  use ElixirRegexWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app>
      <:nav><.link navigate={~p"/"}>Home</.link></:nav>

      <header>
        <h1>Elixir Regex</h1>
      </header>

      <h2>About</h2>
      <p>
        ElixirRegex.com was initially created for the Phoenix Phrenzy
        contest to showcase Phoenix LiveView. It was something that I
        had wanted to make for a while anyway, so this seemed like a
        perfect time with the perfect technology to create it.
        Hopefully you find it useful! I know I'll be using it regularly.
      </p>
      <p>
        -geoffrey
      </p>

      <div style="display: flex; margin-top: 2em;">
        <div style="width: 50%; margin-right: 1em;">
          <h3>Geoffrey Lessel</h3>
          <h4>made it work</h4>
          <p>
            Geo is the author of <a href="https://www.manning.com/books/phoenix-in-action?a_aid=geolessel&a_bid=80a2cec0">
              Phoenix in Action
            </a>, a developer at <a href="https://planning.center">Planning Center</a>,
            and a wannabe renaissance man. Read his sweet tweets at
            <a href="https://twitter.com/geolessel">@geolessel</a>
            and blog at <a href="https://geoffreylessel.com">geoffreylessel.com</a>.
            If you're ever in the San Diego area, hit him up!
          </p>
        </div>

        <div style="width: 50%; margin-left: 1em;">
          <h3>Josh Wilkerson</h3>
          <h4>made it pretty</h4>
          <p>
            Josh is a frontend designer/developer at <a href="https://planning.center">Planning Center</a>,
            and lives in Franklin, TN. When he's not creating sparkling UI
            interfaces, you'll probably find him at one of the many BBQ
            or Hot Chicken joints in Nashville (or running to burn it
            all off). Also occasionally tweeting at <a href="https://twitter.com/jgwilkerson">@jgwilkerson</a>.
          </p>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
