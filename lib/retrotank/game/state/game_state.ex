defmodule Retrotank.Game.State.GameState do
  use GenServer
  require Logger

  alias Retrotank.Game.Core.Player
  alias Retrotank.Game.Core.Players
  @gamestate_server GameState

  # Client

  def start_link(_args) do
    Logger.info "GameState server started"
    GenServer.start_link(__MODULE__, %{}, name: @gamestate_server)
  end

  def init(_init_args) do
    initial_state = %{
      players: %{}
    }

    {:ok, initial_state}
  end

  def state do
    GenServer.call(@gamestate_server, :get_state)
  end

  def join_player(player) when is_binary(player.nickname) do
    GenServer.call(@gamestate_server, {:join_player, player})
  end


  # Server
  def handle_call(:get_state, _from, state), do: {:reply, state, state}

  def handle_call({:join_player, player}, _from, state) do
    %Player{ id: id, nickname: nickname } = player

    cond do
      Players.nickname_used?(state.players, nickname) ->
        {:reply, {:error, :nickname_used}, state}
      Players.id_used?(state.players, id) ->
        {:reply, {:error, :id_used}, state}

      true ->
        player = %{ player | id: 99 }
        players = Map.put(state.players, nickname, player)

        {:reply, {:ok, player}, %{ state | players: players }}
    end
  end

end
