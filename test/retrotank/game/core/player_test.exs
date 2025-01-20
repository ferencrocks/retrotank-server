defmodule PlayerTest do
  use ExUnit.Case

  alias Retrotank.Game.Core.Player
  alias Retrotank.Game.State.GameState

  setup do
    game_id = Retrotank.Utils.Random.uuid()
    {:ok, pid} = GameState.start_link(game_id)
    on_exit fn ->
      Process.exit(pid, :normal)
    end

    {:ok, game_id: game_id, pid: pid}
  end

  test "player initialization returns an initialized player and its game object", state do
    {player, object} = Player.init(state.game_id)

    assert %Retrotank.Game.Core.Player{} = player
    assert is_binary(player.id)

    assert %Retrotank.Game.Object.Tank{} = object
    assert is_binary(object.id)
  end

  test "player can commit itself and its object into the game state", state do
    {player, object} = Player.init(state.game_id)
    :ok = Player.commit_state({player, object})
    state = GameState.state(state.game_id)

    assert state.players[player.id] == player
    assert state.objects[object.id] == object
  end

  test "player can ask its object from game state", state do
    {player, object} = Player.init(state.game_id)
    :ok = Player.commit_state({player, object})
    {:ok, object_received} = Player.object(player)

    assert object_received == object
  end
end
