defmodule Retrotank.Game.State.GamesRegistry do
  use GenServer

  alias Retrotank.Game.Core.Game

  @supervisor_name Retrotank.Game.State.GameStateSupervisor
  @registry_name Retrotank.Game.State.GameStateRegistry

  def start_link(initial_value \\ %{}) do
    DynamicSupervisor.start_link(name: @supervisor_name, strategy: :one_for_one)
    Registry.start_link(keys: :unique, name: @registry_name)

    GenServer.start_link(__MODULE__, initial_value, name: __MODULE__)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def add(name) do
    game_id = Retrotank.Utils.Random.uuid()
    game = %Game{ id: game_id, name: name }

    DynamicSupervisor.start_child(@supervisor_name, {Retrotank.Game.State.GameState, game})
    Registry.register(@registry_name, game_id, game)

    game
  end

  def game_by_id(id) do
    Registry.lookup(@registry_name, id)
    |> List.first()
    |> case do
      nil -> nil
      {_pid, game} -> game
    end
  end

  def all_games(opts \\ []) do
    # Registry.select/2 uses Erlang's match specifications. The pattern {{:_, :_, :"$1"}, [], [:"$1"]} means:
    # :_ matches any key (game_id)
    # :_ matches any pid
    # :"$1" captures the value (game struct) in the first position
    # [] no conditions
    # [:"$1"] return the captured value
    games = Registry.select(@registry_name, [{{:_, :_, :"$1"}, [], [:"$1"]}])

    case Keyword.get(opts, :as, :list) do
      :list -> games
      :map -> games |> Enum.map(fn game -> {game.id, game} end) |> Map.new()
    end
  end

end
