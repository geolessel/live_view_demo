# Elixir Regex

This started as my entry in [Phoenix Phrenzy](https://phoenixphrenzy.com), showing off what [Phoenix](https://phoenixframework.org/) and [LiveView](https://github.com/phoenixframework/phoenix_live_view) can do.

Elixir Regex is a regular expression checker for Elixir. Simply put in your text and the expression you'd like to use as the regular expression, enable some optional modifiers, and see the results in real time. This application may not be very flashy, but it *is* very useful.

<img src="priv/static/images/preview.gif" alt="Elixir Regex" width=400 title="Elixir Regex preview" />

## Development

You need Elixir and Erlang. If you use [asdf](https://asdf-vm.com) or [mise](https://mise.jdx.dev), install the versions in `.tool-versions`. Node.js is not required: assets are bundled with [esbuild](https://hexdocs.pm/esbuild), which `mix setup` downloads.

  * Run `mix setup` to install dependencies and build assets
  * Start the server with `mix phx.server` or `iex -S mix phx.server`
  * Run `mix precommit` before committing (compile with warnings as errors, format, test)

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

`mix setup` downloads esbuild from the npm registry. If that is not
possible, install esbuild yourself and set `MIX_ESBUILD_PATH` to it, for
example in an `.envrc` (ignored by git) for direnv:

```sh
npm install -g esbuild
echo 'export MIX_ESBUILD_PATH="$(which esbuild)"' >> .envrc
```

## Production

The app needs these environment variables at runtime:

  * `SECRET_KEY_BASE` (generate one with `mix phx.gen.secret`)
  * `PHX_HOST` (defaults to `www.elixirregex.com`)
  * `PORT` (defaults to `4000`)
