defmodule Retrotank.Game.Server.GameState do
  use GenServer
  require Logger

  alias Retrotank.Game.Core.Player
  alias Retrotank.Game.Core.Players


  # Client

  def start_link(game_id) do
    server_name = server_name(game_id)

    Logger.info "Starting GameState server #{server_name}..."
    GenServer.start_link(__MODULE__, game_id, name: server_name)
  end

  def init(game_id) do
    initial_state = %{
      players: %{},
      objects: %{},

      game_id: game_id
    }

    {:ok, initial_state}
  end

  @doc """
  Returns the current state
  """
  def state(game_id) when is_binary(game_id) do
    GenServer.call(server_name(game_id), :get_state)
  end

  def join_player(game_id, player) when is_binary(game_id) do
    Logger.debug "Player #{player.id} joined to game #{game_id} "
    GenServer.call(server_name(game_id), {:join_player, player})
  end

  def update_player(game_id, player) when is_binary(game_id) do
    Logger.debug "Player state #{player.id} updated in game #{game_id} "
    GenServer.call(server_name(game_id), {:join_player, player})
  end


  def add_object(game_id, object) do
    GenServer.call(server_name(game_id), {:add_object, object})
  end

  def object_by_id(game_id, object_id) when is_binary(game_id) and is_binary(object_id) do
    GenServer.call(server_name(game_id), {:get_object_by_id, object_id})
  end


  defp server_name(game_id) when is_binary(game_id) do
    String.to_atom "GameState_" <> game_id
  end


  # Server

  def handle_call(:get_state, _from, state), do: {:reply, state, state}

  def handle_call({:join_player, player}, _from, state) do
    players = Map.put(state.players, player.id, player)

    {:reply, :ok, %{ state | players: players }}

    # cond do
    #   Players.nickname_used?(state.players, nickname) ->
    #     {:reply, {:error, :nickname_used}, state}

    #   true ->
    #     player = %{ player | id: 99, game_id: state.game_id }
    #     players = Map.put(state.players, nickname, player)

    #     {:reply, {:ok, player}, %{ state | players: players }}
    # end
  end

  def handle_call({:add_object, object}, _from, state) do
    objects = Map.put(state.objects, object.id, object)

    {:reply, :ok, %{ state | objects: objects }}
  end

  def handle_call({:get_object_by_id, object_id}, _from, state) do
    object_found = state.objects[object_id]
    case object_found do
      %{} -> {:reply, {:ok, object_found}, state}
      _ -> {:reply, {:error, :object_not_found}, state}
    end
  end

end
