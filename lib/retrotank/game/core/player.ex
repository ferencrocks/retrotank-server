defmodule Retrotank.Game.Core.Player do
  defstruct ws_pid: nil,
    id: Retrotank.Utils.Random.uuid(),
    nickname: "anonymous",

    game_id: nil,
    object_id: nil

  @gamestate_module Retrotank.Game.State.GameState

  require Retrotank.Game.Core.Movement

  alias Retrotank.Game.State.PlayersRegistry
  alias Retrotank.Game.Core.Player


  defimpl Jason.Encoder do
    def encode(player, opts) do
      Jason.Encode.map(%{ id: player.id, nickname: player.nickname }, opts)
    end
  end

  def assign_game(player, game_id) when is_binary(game_id) do
    %{ player | game_id: game_id }
  end

  def assign_object(player, %{ id: object_id }) do
    %{ player | object_id: object_id }
  end

  # def commit_state({player, player_object}) do
  #   :ok = call_gamestate(player.game_id, :add_object, [player_object])
  #   :ok = call_gamestate(player.game_id, :update_player, [player])
  # end

  # def commit_state(player) do
  #   :ok = call_gamestate(player.game_id, :update_player, [player])
  # end

  # @doc """
  # Returns the player's game object.
  # """
  def object(player_id) when is_binary(player_id) do
    player = player_by_id(player_id)
    call_gamestate(player.game_id, :object_by_id, [player.object_id])
  end

  def object(%Player{id: player_id}) do
    object(player_id)
  end

  defp call_gamestate(game_id, function_name, args) when is_binary(game_id) do
    apply(@gamestate_module, function_name, [game_id | args])
  end

  defp player_by_id(player_id) do
    {:ok, player} = PlayersRegistry.player_by_id(player_id)
    player
  end
end
