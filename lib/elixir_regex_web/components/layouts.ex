defmodule ElixirRegexWeb.Layouts do
  @moduledoc """
  Layouts shared by every page.
  """
  use ElixirRegexWeb, :html

  embed_templates "layouts/*"

  @doc """
  Wraps page content in the site container and footer.

      <Layouts.app>
        <:nav><.link navigate={~p"/about"}>About</.link></:nav>
        <h1>Content</h1>
      </Layouts.app>
  """
  slot :nav
  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <div class="app">
      <div class="container">
        <div class="content">
          {render_slot(@inner_block)}

          <footer>
            <nav>{render_slot(@nav)}</nav>
            <p>© 2019&ndash;2020 Geoffrey Lessel</p>
          </footer>
        </div>
      </div>
    </div>
    """
  end
end
