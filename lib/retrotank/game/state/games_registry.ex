defmodule Retrotank.Game.State.GamesRegistry do
  use Agent

  alias Retrotank.Game.Core.Game

  def start_link(initial_value \\ %{}) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def add(id, name) do
    game = %Game{ id: id, name: name }
    Agent.update(__MODULE__, fn(games) -> Map.put(games, id, game) end)

    game
  end

  def game_by_id(id) do
    Agent.get(__MODULE__, &(&1))
    |> Map.get(id)
  end

  def all_games(opts \\ []) do
    games = Agent.get(__MODULE__, &(&1))

    case Keyword.get(opts, :as, :map) do
      :map -> games
      :list -> Enum.map(games, fn {_id, game} -> game end)
    end
  end
end
