defmodule Retrotank.Game.Core.Players do
  alias Retrotank.Game.Core.Player

  def player_by_nickname(players, nickname) when is_binary(nickname) do
    player = Enum.find(players, &(&1.nickname == nickname))
    case player do
      %Player{} -> {:ok, player}
      nil -> :not_found
    end
  end

  def player_by_id(players, id) when is_binary(id) do
    player = Map.get(players, id)
    case player do
      %Player{} -> {:ok, player}
      nil -> :not_found
    end
  end

  def id_used?(players, id) do
    Map.has_key?(players, id)
  end

  def nickname_used?(players, nickname) when is_binary(nickname) do
    Enum.any?(players, &(&1.nickname == nickname))
  end
end
