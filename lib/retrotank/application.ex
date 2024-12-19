defmodule Retrotank.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    require Logger

    children = [
      # Starts a worker by calling: Retrotank.Worker.start_link(arg)
      # {Retrotank.Worker, arg}

      {Plug.Cowboy, scheme: :http, plug: Retrotank.Router, options: [port: 8080]},
      {Retrotank.Game.State.GamesRegistry, %{}},
      {Retrotank.Game.State.PlayersRegistry, %{}},
      {Retrotank.Game.Server.GameState, Retrotank.Utils.Random.uuid}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    Logger.info "Starting the main supervisor..."
    opts = [strategy: :one_for_one, name: Retrotank.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
