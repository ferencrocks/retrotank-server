defmodule Retrotank.Game.State.PlayersRegistry do
  use Agent

  alias Retrotank.Game.Core.Player

  def start_link(initial_value \\ %{}) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def upsert(player) do
    %Player{ id: id } = player
    :ok = Agent.update(__MODULE__, fn(players) -> Map.put(players, id, player) end)

    {:ok, player}
  end

  def update(player_id, mapper) do
    {:ok, player} = player_by_id(player_id)
    player
    |> mapper.()
    |> upsert()
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

  def player_exists?(player_id) do
    Agent.get(__MODULE__, fn(players) -> Map.has_key?(players, player_id) end)
  end
end
