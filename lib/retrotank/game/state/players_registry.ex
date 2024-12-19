defmodule Retrotank.Game.State.PlayersRegistry do
  use Agent

  alias Retrotank.Game.Core.Player

  def start_link(initial_value \\ %{}) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def upsert(player) do
    %Player{ id: id } = player
    Agent.update(__MODULE__, fn(players) -> Map.put(players, id, player) end)

    player
  end

  def player_by_id(id) do
    player = Agent.get(__MODULE__, fn(players) -> Map.get(players, id) end)

    case player do
      %Player{} -> {:ok, player}
      nil -> {:error, :not_found}
    end
  end

  def all_players(opts \\ []) do
    players = Agent.get(__MODULE__, &(&1))

    case Keyword.get(opts, :as, :map) do
      :map -> players
      :list -> Enum.map(players, fn {_id, player} -> player end)
    end
  end
end
