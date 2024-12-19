defmodule Retrotank.Game.Core.Player do
  defstruct ws_conn: nil,
    id: Retrotank.Utils.Random.uuid(),
    nickname: "anonymous",

    game_id: nil,
    object_id: nil

  @gamestate_module Retrotank.Game.Server.GameState

  require Retrotank.Game.Core.Movement


  defimpl Jason.Encoder do
    def encode(player, opts) do
      Jason.Encode.map(%{ id: player.id, nickname: player.nickname }, opts)
    end
  end

  def assign_object(player, %{ id: object_id }) do
    %{ player | object_id: object_id }
  end

  def commit_state({player, player_object}) do
    :ok = call_gamestate(player.game_id, :add_object, [player_object])
    :ok = call_gamestate(player.game_id, :update_player, [player])
  end

  def commit_state(player) do
    :ok = call_gamestate(player.game_id, :update_player, [player])
  end

  @doc """
  Returns the player's game object.
  """
  def object(player) when is_binary(player.game_id) and is_binary(player.object_id) do
    call_gamestate(player.game_id, :object_by_id, [player.object_id])
  end

  defp call_gamestate(game_id, function, args) when is_binary(game_id) do
    apply(@gamestate_module, function, [game_id | args])
  end
end
