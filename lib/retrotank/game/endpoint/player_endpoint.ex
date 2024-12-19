defmodule Retrotank.Game.Endpoint.Player do
  use Plug.Router

  alias Retrotank.Game.Server.GameState
  alias Retrotank.Game.State.PlayersRegistry
  alias Retrotank.Game.Core.Player


  plug :match
  plug Plug.Parsers,
     parsers: [:urlencoded, :json],
     json_decoder: Jason

  plug CORSPlug
  plug :dispatch

  post "/register" do
    %{:body_params => %{"nickname" => nickname}} = conn
    send_resp(conn, 200, Jason.encode! register_player(nickname))
  end

  post "/joingame" do
    %{:body_params => %{"player_id" => player_id, "game_id" => game_id}} = conn
    {:ok, player} = PlayersRegistry.player_by_id(player_id)
    {:ok, join_response} = join_game(player, game_id)

    send_resp(conn, 200, Jason.encode! join_response)
  end


  defp register_player(nickname) do
    player = %Player{ nickname: nickname }
    PlayersRegistry.upsert player
  end

  defp join_game(player, game_id) do
    {:ok, player} = GameState.join_player(game_id, player)
    PlayersRegistry.upsert player
  end
end
