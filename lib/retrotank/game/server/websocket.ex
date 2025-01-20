defmodule Retrotank.Game.Server.Websocket do
  alias Retrotank.Game.Core.Object
  alias Retrotank.Game.Core.Player
  alias Retrotank.Game.State.PlayersRegistry
  alias Retrotank.Game.State.GameState
  alias Retrotank.Utils.Helpers
  require Logger

  def init(requester = %{player_id: player_id}) do
    {:ok, player} = PlayersRegistry.update(player_id, fn player -> %{player | ws_pid: self()} end)

    broadcast(player, %{
      type: "player_joined",
      data: player
    })

    {:ok, requester}
  end

  def handle_in({message, [opcode: :text]}, state) do
    [action | [args]] = Jason.decode!(message)

    {:ok, player} = PlayersRegistry.player_by_id(state.player_id)
    result = apply(__MODULE__, :handle_request, [action | [player | args]])

    Logger.debug "IN [Player##{state.player_id}] --> #{action}(#{inspect(args) |> String.trim("[") |> String.trim("]")})"

    {:reply, :ok, {:text, Jason.encode! result}, state}
  end

  def handle_info({:broadcast, message}, state) do
    {:push, {:text, Jason.encode!(message)}, state}
  end

  def terminate(:timeout, state) do
    {:ok, state}
  end

  def broadcast(%Player{ws_pid: ws_pid}, message) do
    Process.send(ws_pid, {:broadcast, message}, [])
  end


  def handle_request("player.direction", %Player{} = player, direction, true) when is_binary(player.game_id) do
    {:ok, _} = Player.object(player)
    |> Helpers.unwrap_result()
    |> Object.direction(String.to_atom direction)
    |> Object.is_moving(true)
    |> GameState.update_object(player.game_id)

    # Broadcast the updated state to the player
    # message = Jason.encode!(%{
    #   type: "state_update",
    #   data: object
    # })
    # Process.send(self(), {:broadcast, message}, [])

    IO.inspect "Player started to move to direction #{direction}"
  end

  def handle_request("player.direction", %Player{} = player, direction, false) do
    IO.inspect "Player stopped moving to direction #{direction}"
  end
end
