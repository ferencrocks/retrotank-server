defmodule Retrotank.Game.State.GameState do
  use GenServer
  require Logger

  #alias Retrotank.Game.Core.Game
  #alias Retrotank.Game.Core.Player
  #alias Retrotank.Game.Core.Players

  alias Retrotank.Game.Core.Game
  alias Retrotank.Game.Core.Object
  alias Retrotank.Game.State.PlayersRegistry
  alias Retrotank.Game.Core.Player
  alias Retrotank.Game.Object.Tank


  # Client

  def start_link(game = %Game{}) do
    server_name = server_name(game.id)

    Logger.info "Starting GameState server #{server_name}..."
    GenServer.start_link(__MODULE__, game, name: server_name)
  end

  def init(game = %Game{}) do
    initial_state = %{
      players: MapSet.new(),
      objects: %{},
      game: game,

      internal: %{
        last_object_id: 0
      }
    }

    {:ok, initial_state}
  end

  @doc """
  Returns the current state
  """
  def state(game_id) when is_binary(game_id) do
    GenServer.call(server_name(game_id), :get_state)
  end

  def player(player_id) do
    {:ok, player} = PlayersRegistry.player_by_id(player_id)

    player
  end

  def players(game_id) do
    %{ players: players } = state(game_id)

    players
    |> MapSet.to_list()
    |> Enum.map(&(player &1))
  end

  def join_player(game_id, player, opts \\ []) when is_binary(game_id) do
    tank_color = Keyword.get(opts, :tank_color, :green)
    tank_size = Keyword.get(opts, :tank_size, 0)
    {:ok, tank} = add_object(%Tank{props: %{ color: tank_color, size: tank_size }}, game_id)

    player = player
    |> Player.assign_game(game_id)
    |> Player.assign_object(tank)

    Logger.debug "Player #{player.id} joined to game #{game_id} "
    GenServer.call(server_name(game_id), {:join_player, player})
  end

  def update_player(game_id, player) when is_binary(game_id) do
    Logger.debug "Player state #{player.id} updated in game #{game_id} "
    GenServer.call(server_name(game_id), {:join_player, player})
  end


  def add_object(object, game_id) when is_nil(object.id) do
    GenServer.call(server_name(game_id), {:add_object, object})
  end

  def update_object(object, game_id) when not is_nil(object.id) do
    GenServer.call(server_name(game_id), {:update_object, object})
  end

  def object_by_id(game_id, object_id) when is_binary(game_id) and is_integer(object_id) do
    GenServer.call(server_name(game_id), {:get_object_by_id, object_id})
  end


  defp server_name(game_id) when is_binary(game_id) do
    String.to_atom "GameState_" <> game_id
  end


  # Server

  def handle_call(:get_state, _from, state), do: {:reply, state, state}

  def handle_call({:join_player, player = %Player{ id: player_id }}, _from, state) do
    players = MapSet.put(state.players, player_id)

    {:reply, {:ok, player}, %{ state | players: players }}

    # cond do
    #   Players.nickname_used?(state.players, nickname) ->
    #     {:reply, {:error, :nickname_used}, state}

    #   true ->
    #     player = %{ player | id: 99, game_id: state.game_id }
    #     players = Map.put(state.players, nickname, player)

    #     {:reply, {:ok, player}, %{ state | players: players }}
    # end
  end

  def handle_call({:add_object, object}, _from, state) when is_nil(object.id) do
    # New object. It gets an incremented id.
    object_id = state.internal.last_object_id + 1
    object = Object.assign_id(object, object_id)
    state = %{ state | internal: %{ last_object_id: object_id } }

    objects = Map.put(state.objects, object.id, object)
    state = %{ state | objects: objects }

    {:reply, {:ok, object}, state}
  end

  def handle_call({:update_object, object}, _from, state) when not is_nil(object.id) do
    objects = Map.put(state.objects, object.id, object)
    state = %{ state | objects: objects }

    {:reply, {:ok, object}, state}
  end

  def handle_call({:get_object_by_id, object_id}, _from, state) do
    object_found = state.objects[object_id]
    case object_found do
      %{} -> {:reply, {:ok, object_found}, state}
      _ -> {:reply, {:error, :object_not_found}, state}
    end
  end

end
