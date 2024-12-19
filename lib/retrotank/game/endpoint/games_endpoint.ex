defmodule Retrotank.Game.Endpoint.Games do
  alias Retrotank.Game.State.GamesRegistry
  use Plug.Router

  plug :match
  plug Plug.Parsers,
     parsers: [:urlencoded, :json],
     json_decoder: Jason

  plug CORSPlug
  plug :dispatch

  get "/all" do
    send_resp(conn, 200, Jason.encode!(GamesRegistry.all_games as: :list))
  end
end
