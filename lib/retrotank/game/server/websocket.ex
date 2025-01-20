defmodule Retrotank.Game.Server.Websocket do
  alias Retrotank.Game.Core.Player
  alias Retrotank.Game.State.PlayersRegistry

  require Logger

  def init(requester) do
    %{player_id: player_id} = requester
    PlayersRegistry.update(player_id, fn player -> %{player | ws_pid: self()} end)

    {:ok, requester}
  end

  def handle_in({message, [opcode: :text]}, state) do
    [action | [args]] = Jason.decode!(message)
    IO.inspect [action | args]
    apply(__MODULE__, :handle_request, [action | args])

    Logger.debug "IN [Player##{state.player_id}] --> #{action}(#{inspect(args) |> String.trim("[") |> String.trim("]")})"

    {:reply, :ok, {:text, "pong"}, state}
  end

  def handle_info(msg, state) do
IO.inspect msg
    {:push, "kaxika", state}
  end

  def terminate(:timeout, state) do
    {:ok, state}
  end


  def handle_request("player.direction", direction, true) do
    IO.inspect "Player started to move to direction #{direction}"
  end

  def handle_request("player.direction", direction, false) do
    IO.inspect "Player stopped moving to direction #{direction}"
  end
end
